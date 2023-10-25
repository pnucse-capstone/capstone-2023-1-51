import os

import solcx

from djangoProject.compileSol import *
from djangoProject.createImage import *
import tensorflow as tf
from djangoProject.grad_cam_heatmap import get_vulnerability_location


def get_enclosing_function(source, begin, end):
    # 라인별로 나누기
    lines = source.split('\n')

    # 타겟 라인과 컬럼 찾기
    total_chars = 0
    target_line_begin = target_line_end = None
    for i in range(len(lines)):
        if total_chars + len(lines[i]) >= begin and target_line_begin is None:
            target_line_begin = i

        if total_chars + len(lines[i]) >= end:
            target_line_end = i
            break

        total_chars += len(lines[i]) + 1  # '\n' 문자 고려

    if target_line_begin is None or target_line_end is None:
        return "Target index out of range."

    # 함수 시작과 끝 찾기
    start_index = end_index = max(target_line_begin, target_line_end)

    while start_index > 0 and 'function' not in lines[start_index] and 'contract' not in lines[start_index]:
        start_index -= 1

    while end_index < len(lines) - 1 and '}' not in lines[end_index] and 'function' not in lines[end_index]:
        end_index += 1

    # 함수 반환하기
    return '\n'.join(lines[start_index:end_index + 1]), start_index, end_index


def main(source):
    pred = [[0.0]]

    version = extract_compiler_version(source)
    if version[0] == '^':
        version = version[1:]

    install_version(version)
    select_version(version)

    compiled_sol = compile_source(source)
    keys = compiled_sol.keys()

    for key in keys:
        contract_interface = compiled_sol[key]
        contract_name = key.split(':')[1]
        print('contract name: ', contract_name)
        asm = contract_interface['asm']
        bytecode = contract_interface['bin']
        # print(asm)
        # print(bytecode)
        if (asm is None) or (bytecode is None):
            continue

        pixel_colors = create_pixels(bytecode)
        if len(pixel_colors) != 10000:
            continue
        create_image(contract_name, pixel_colors)
        modelPath = "djangoProject/my_model1.h5"
        model = tf.keras.models.load_model(modelPath)

        image_path = "../"+contract_name + '.png'
        pred, idxs = get_vulnerability_location(image_path, model)
        if pred < 0.5:
            continue
        print(pred)
        print(idxs)

        filtered_asm1 = [d for d in asm['.code'] if d.get('name') != "tag"]
        filtered_asm1.append({'begin': 0, 'end': 0, 'name': 'STOP'})
        filtered_asm2 = [d for d in asm['.data']['0']['.code'] if d.get('name') != "tag"]
        asms = filtered_asm1 + filtered_asm2

        for index in idxs:
            if index >= len(asms):
                continue
            begin = asms[index].get('begin')
            end = asms[index].get('end')
            print('---------------------------------------------------')
            print('opcode idx:', index)
            print('begin:', begin)
            print('end:', end)
            print('---------------------------------------------------')
            print('Begin line:', source.count('\n', 0, begin) + 1)
            print('End line:', source.count('\n', 0, end) + 1)
            print('source:\n', source[begin:end + 1])
            print('---------------------------------------------------')
            print('Function source:')
            print(get_enclosing_function(source, begin, end))
            code, startIndex, endIndex = get_enclosing_function(source, begin, end)
            return pred, code, startIndex, endIndex

    return pred, "null", 0, 0
