# 🛒 전자기기 쇼핑몰 앱 - 상세페이지 

Flutter로 제작한 전자기기 쇼핑몰 앱입니다.  
자전거, 맥북, 스마트폰 등 다양한 상품을 리스트로 보여주고, 상세페이지에서 설명을 확인한 후 수량을 조절해 장바구니에 담을 수 있습니다.
그 중 저는 상세페이지를 맡았습니다 (🖐🏻'-' )

---

## ✅ 기능 요약

### 🔹 필수 기능
- ✅ 홈 화면: 상품 목록(이미지, 이름, 가격) 출력
- ✅ 상품 상세 페이지: 이미지, 상세 설명, 수량 조절, 총 가격, 구매 다이얼로그
- ✅ 장바구니 기능: 수량에 따라 총액 계산 및 구매 확인 팝업

### 🔸 도전 기능
- ✅ Unsplash 기반 랜덤 이미지 사용
- ✅ 감성적인 마케팅 문구 자동 출력
- ✅ 긴 상품 설명 스크롤 처리
- ✅ 상품 가격 포매팅(₩ 1,000,000 형식)
---
## 🧪 Product Details Page 작업 중 시행착오 기록

- 이미지 URL 오류 발생 → 랜덤 Unsplash URL 추가로 해결
- `description`이 비어 있을 때 fallback이 적용되지 않던 이슈 수정
- 총 가격 계산 중 `int` vs `double` 타입 충돌 발생 → `NumberFormat`으로 처리

## 🧠 개발 설계

### 📁 디렉토리 구조

```plaintext

lib/
├── data/
│   └── entity/               # ProductEntity 정의
├── ui/
│   ├── home/                 # Home 화면
│   ├── product_details/      # 상세 페이지 UI
│   ├── shopping_cart/        # 장바구니 뷰모델
│   └── product_registration/ # 상품 등록용 뷰
├── main_detail.dart          # 앱 진입점
└── main.dart                 # 라우터 및 설정
```
![image](https://github.com/user-attachments/assets/2e432b0d-e19c-4e59-a884-5ea05d3317c2)

📁📁 main.dart가 앱 진입점입니다.


---

### 💡 이해도 및 직관성
- 변수명과 함수명은 `buildSeatBox`, `selectedSeat` 등 기능 기반 직관적으로 구현
- 모든 주요 함수에는 주석 추가로 가독성 향상

---

## ⚠️ 상세페이지 예외처리 (Lina YOO)
- ✅ 수량 0 이하/100 이상 제한
- ✅ 상품 설명 미입력 시 자동 마케팅 설명 제공
- ✅ 이미지 불러오기 실패 시 기본 에러 아이콘 출력
- ✅ 구매 수량 없이 구매 버튼 클릭 시 팝업 차단
- 
---

## 📌 커밋 컨벤션
- 총 **10회 이상의 커밋** 기록
- 커밋 메시지는 다음과 같은 규칙을 따릅니다:
 - feat: 기능 구현
 - fix: 버그 수정
 - style: 코드 포맷팅, 스타일 변경
 - refactor: 리팩토링

---

## 🎨 스크린샷
> 아래는 앱 상세페이지 새행착오 주요 화면 예시입니다.
아래는 앱 상세페이지에서 Unsplash API를 활용해 랜덤 자연 이미지를 가져오고,
natureTexts 맵과 refreshContent() 함수를 통해 해당 이미지를 설명하는 텍스트를 무작위로 매칭하려고 했던
시도 과정의 주요 화면 예시입니다.

>오류 요약
카테고리별로 랜덤 이미지를 불러온 뒤, natureTexts에서 카테고리(예: forest, ocean)에 맞는 제목·설명을 골라 표시하려 했으나,
종종 “아이폰 → 숲속”, “개구리 → 치즈버거”처럼 전혀 맞지 않는 매칭이 발생하는 오류가 지속되었습니다.

결국 아이템마다 개별 텍스트를 직접 정의하는 방식으로 전환했습니다.


🧐 Unsplash API 에 따라 natureTexts 맵 정의→, refreshContent 함수에서 랜덤하게 선택 하려고 했으나 지속 오류

| 홈 화면 | Unsplash API TEST | refreshContent TEST |
|--------|-------------|----------------|
| ![image](https://github.com/user-attachments/assets/05907399-d7f1-472c-a2bf-1df6fb6d2185) | ![스크린샷 2025-04-04 222624](https://github.com/user-attachments/assets/7aa89cfe-b2c7-4005-a2c2-bbcd03829b4f) | ![스크린샷 2025-04-04 211836](https://github.com/user-attachments/assets/b8c984bf-c98c-4418-8e4a-f4ae6d0c2258)
|

🌙 정상적인 화면(개별 텍스트를 직접 정의하는 방식)
| 홈 화면 | 역 선택 화면 | 좌석 선택 화면 |
|--------|-------------|----------------|
|![image](https://github.com/user-attachments/assets/681fbbed-672a-40c1-bb1f-de008b9bedd8)|![image](https://github.com/user-attachments/assets/5aab417a-bb97-4101-ab3d-b008c91b73e4)| ![image](https://github.com/user-attachments/assets/e13e61ba-b050-4ace-ab4f-66237340a39c)|

⚙️ main.dart 내부 테마 설정 code
```plaintext
MaterialApp(
  title: '전자기기 스토어',
  theme: ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.blue,
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  ),
  themeMode: ThemeMode.system, // 시스템 설정 자동 적용
  home: const HomePage(),
);

```


---

## 🛠 상세페이지 사용 기술

 - Flutter 3.7
 - Riverpod
 - Flutter Hooks
 - Dart
 - Intl (숫자 포맷팅)
 - Git & GitHub

---

## 👨‍💻 개발자
- GitHub: [Linayoo01](https://github.com/Linayoo01)


