# Smart-contract 취약점 탐지 툴

---

# 1. 프로젝트 소개

---

스마트 컨트랙트의 보안 취약점을 자동으로 탐지하여, 체계적으로 분석하고 평가하는 도구이다. 또한, 사용자에게 취약점의 위치를 시각적으로 보여주는 UI를 제공하여, 취약점이 포함된 코드 부분도 함께 제시한다.

# 2. 팀 소개

---

### 컴쪽이

2023 전기 부산대학교 졸업과제 51팀

### 팀원

- 김윤하
    - contact: yunha@pusan.ac.kr
    - 전처리 모듈 개발, Code Mapping 모듈 개발
    - 보고서 작성, 모델 테스트 및 성능 평가
- 윤지원
    - contact: jion3422@pusan.ac.kr
    - 모델 설계 및 구현, Code Mapping 모듈 개발
    - 보고서 작성, 모델 테스트 및 성능 평가
- 최지원
    - contact: cjw0908@pusan.ac.kr
    - 프론트 및 백엔드 개발
    - 보고서 작성, 모델 테스트 및 성능 평가

# 3. 시스템 구성도

---

### 전체 시스템 구성도

![시스템구성도](https://github.com/pnucse-capstone/capstone-2023-1-51/blob/main/docs/image/Untitled.png)
1. 사용자가 Solidity Code 파일을 업로드하면, 해당 파일을 컴파일하고 전처리 과정을   거쳐 CNN 모델의 입력 형식에 맞춰 이미지로 변환하여 모델을 통해 취약점 여부를 판단한다.
2. 만약 취약점이 있다고 판단 시, Grad-CAM 기법을 사용해 판단한 결과에 가장 큰 영향을 미친 위치를 추출한다.
3. 해당 위치의 OP Code를 찾아 Code Mapping Module로 전송한다.
4. 최종적으로 사용자에게 재진입 공격 취약점의 확률 및 위치 정보를 제공한다

### Directory Structure

```bash
📦
├─ djangoProject             # backend project
│   
├─ docs                      
│
└─ smart_contract.           #frontend project    
```

### **Tech Stack**

- Python
- Solidity
- Flutter
- Django

# 4. 소개 및 시연 영상

---

### 소개 영상

- 링크 추가 예정

### 발표자료
- [발표자료](https://prezi.com/view/YmYvDqkG4TGhjsjwGq7R/)



# 5. 설치 및 사용법

---

### Requirements

For building and running the application yoe need:

- Flutter SDK
- Python - Python version 3.9 이상
- Django

### Installation

1. git clone

```bash
git clone https://github.com/pnucse-capstone/capstone-2023-1-51.git
```

1. 복제된 프로젝트로 이동

```bash
cd capstone-2023-1-51
```

### Backend

1. Django 프로젝트 폴더로 이동

```bash
cd djangoProject
```

1. Python 가상환경을 생성하고 활성화

```bash
python -m venv venv
source myenv/bin/activate  # Linux/Mac
myenv\Scripts\activate  # Windows
```

1. 필요한 python 패키지를 설치

```bash
pip install -r requirements.txt
```

1. django 서버 시작

```bash
python manage.py runserver
```

### Frontend

1. flutter 프로젝트로 이동

```bash
cd smart_contract
```

1. 의존성 설치

```bash
flutter pub get
```

1. Flutter 웹 지원을 활성화

```bash
flutter config --enable-web
```

1. 웹으로 앱을 컴파일하고 실행

```bash
flutter run -d chrome
```
