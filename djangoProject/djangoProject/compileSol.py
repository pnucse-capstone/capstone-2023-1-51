import subprocess
from solcx import compile_source
import re


# 소스코드 컴파일
def compile_source_file(source):
    return compile_source(source)


# 솔리디티 컴파일러 버전 추출
def extract_compiler_version(solidity_code):
    # 정규식 패턴으로 pragma 문 또는 컴파일러 지시어를 찾습니다.
    pragma_pattern = re.compile(r'pragma\s+solidity\s+["\']?([^\s"\'\;]+)["\']?\s*;', re.IGNORECASE)
    matches = pragma_pattern.findall(solidity_code)

    if matches:
        # pragma 문 또는 컴파일러 지시어에서 버전 정보 추출
        compiler_version = matches[0]
        return compiler_version
    else:
        return None


# 솔리디티 컴파일러 해당 버전 설치
def install_version(version):
    cmd_command = f"solc-select install {version}"
    install_process = subprocess.Popen(cmd_command, stdout=subprocess.PIPE, shell=True)
    output, error = install_process.communicate()
    print(output.decode())


# 솔리디티 컴파일러 버전 선택
def select_version(version):
    cmd_command = f"solc-select use {version}"
    select_process = subprocess.Popen(cmd_command, stdout=subprocess.PIPE, shell=True)
    output, error = select_process.communicate()
    print(output.decode())


# 솔리디티 컴파일러 버전 확인
def check_version():
    check_cmd = "solc --version"
    check_process = subprocess.Popen(check_cmd, stdout=subprocess.PIPE, shell=True)
    output, error = check_process.communicate()
    print(output.decode())