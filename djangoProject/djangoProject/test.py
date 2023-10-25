from solcx import compile_source
import re
import subprocess
import pprint



contract_source_code = '''
/*
 * @source: https://ethernaut.zeppelin.solutions/level/0xf70706db003e94cfe4b5e27ffd891d5c81b39488
 * @author: Alejandro Santander
 * @vulnerable_at_lines: 24
 */

pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      // <yes> <report> REENTRANCY
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  function() public payable {}
}

'''

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


def complie_get_sourceMap_byteCode(contract_source_code):
    version = extract_compiler_version(contract_source_code)
    if version[0] == '^':
        version = version[1:]
    #install_version(version)
    select_version(version)
    compiled_sol = compile_source(contract_source_code)
    contract_interface = compiled_sol['<stdin>:Reentrance']
    asm = contract_interface['asm']
    Bytecode = contract_interface['bin']
    return Bytecode, asm

push = {'60': 1, '61': 2, '62': 3, '63': 4, '64': 5, '65': 6, '66': 7, '67': 8, '68': 9, '69': 10,
        '6a': 11, '6b': 12, '6c': 13, '6d': 14, '6e': 15, '6f': 16, '70': 17, '71': 18, '72': 19, '73': 20,
        '74': 21, '75': 22, '76': 23, '77': 24, '78': 25, '79': 26, '7a': 27, '7b': 28, '7c': 29, '7d': 30,
        '7e': 31, '7f': 32}

# 바이트코드를 디스어셈블리하는 함수
def disasm_bytecode(bytecode):
    i = 0
    opcodes = []
    while i < len(bytecode):
        op = bytecode[i:i + 2]
        i += 2

        if op in push.keys():  # 이 부분은 PUSH 명령어를 체크
            n = push[op]
            op += bytecode[i:i+(2*n)]
            i += 2 * n

        opcodes.append(op)
    return opcodes


bytecode, asm = complie_get_sourceMap_byteCode(contract_source_code)

filtered_asm1 = [d for d in asm['.code'] if d.get('name') != "tag"]
filtered_asm1.append({'begin': 0, 'end': 0, 'name': 'STOP'}) # .code 끝부분 RETURN 뒤에 STOP 추가
filtered_asm2 = [d for d in asm['.data']['0']['.code'] if d.get('name') != "tag"]
asms = filtered_asm1 + filtered_asm2
