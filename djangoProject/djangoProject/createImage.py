from PIL import Image

push = {'60': 1, '61': 2, '62': 3, '63': 4, '64': 5, '65': 6, '66': 7, '67': 8, '68': 9, '69': 10,
        '6a': 11, '6b': 12, '6c': 13, '6d': 14, '6e': 15, '6f': 16, '70': 17, '71': 18, '72': 19, '73': 20,
        '74': 21, '75': 22, '76': 23, '77': 24, '78': 25, '79': 26, '7a': 27, '7b': 28, '7c': 29, '7d': 30,
        '7e': 31, '7f': 32}


# 바이트 단위로 나눠 RGB값 지정
def create_pixels(bytecode):
    pixel_colors = []
    i = 0
    push_keys = push.keys()
    while i < len(bytecode):
        byte = bytecode[i:i + 2]
        i += 2
        r = int(byte, 16)
        g = 0
        b = 0
        if byte in push_keys:
            g = int(bytecode[i:i + 2], 16)
            i += 2
            n = push[byte]
            if n != 1:
                b = int(bytecode[i:i + 2], 16)
                i += 2 * (n - 1)
        if len(pixel_colors) < 10000:
            pixel_colors.append((r, g, b))
        else:
            break

    while len(pixel_colors) < 10000:
        pixel_colors.append((0, 0, 0))

    if i < len(bytecode):
        pixel_colors = []
    return pixel_colors


def create_image(file_name, pixel_colors):
    width = 10000
    if width != 0:
        image = Image.new('RGB', (width, 1))  # 이미지 생성
        pixels = pixel_colors   # 픽셀 색상 설정
        image.putdata(pixels)   # 이미지에 픽셀 색상 적용
        image.save(file_name + '.png')