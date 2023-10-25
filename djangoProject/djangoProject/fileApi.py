import json
from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt

from djangoProject.main import main


@csrf_exempt
def create_file(request):
    if request.method == 'POST':
        byte_data = request.body
        decoded_data = byte_data.decode('utf-8')
        requestData = json.loads(decoded_data)
        source = requestData['code']
        print(decoded_data)

        probability = 0.0
        startIndex = 0
        endIndex = 0
        probability, code , startIndex , endIndex = main(source)
        value = float(probability[0][0])
        value = round(value * 100, 2)

        # 문자열 형식 지정을 사용하여 값을 문자열에 포함
        if (code != "null"):
            result = "취약점 확률: {}%".format(value)  # 또는 f"취약점 확률: {value}%"
            result += "\n취약점 종류: reentrancy"
        else:
            result = "취약점 확률: {}%".format(value)  # 또는 f"취약점 확률: {value}%"
            result += "\n취약점이 없습니다."
            code = "\n탐지된 취약점이 없습니다.\n"



        json_data = {
            'code': code,
            'probability': value,
            'result': result,
            'startIndex': startIndex,
            'endIndex': endIndex
        }

        print(json_data)
        return JsonResponse(json_data)
    else:
        return JsonResponse({"message": "Not a POST request"})


