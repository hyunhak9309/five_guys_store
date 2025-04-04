import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ProductDetailsPage extends HookConsumerWidget {
  static const path = '/product_details'; // 라우트 경로 (필요시 사용)
  final ProductEntity product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 수량 상태 관리 (1~99)
    final productNum = useState(1);

    // 장바구니 뷰모델
    final viewModelFC = ref.read(shoppingCartViewModelProvider.notifier);

    // 가격 포맷터
    final NumberFormat formatter = NumberFormat('#,###');
    // 수량 증가 버튼 클릭 시 수량 증가(증가일 경우 true, 감소일 경우 false 로 호출)
    // 수량 표현하는 부분은 productNum.value.toString() 로 텍스트 위젯 안에 표현
    // 수량 증감 함수
    void updateProductNum(bool isPlus) {
      if (isPlus) {
        if (productNum.value < 99) {
          productNum.value++;
        }
      } else {
        if (productNum.value > 1) {
          productNum.value--;
        }
      }
    }

    // 구매 완료 다이얼로그
    void showConfirmationDialog() {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('구매 완료'),
              content: Text('${product.name}을(를) ${productNum.value}개 구매했습니다.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('확인'),
                ),
              ],
            ),
      );
    }

    // 구매 확인 다이얼로그
    void showPurchaseDialog() {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('${product.name}을(를) ${productNum.value}개 구매하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    // 장바구니에 추가 viewModelFC.addProduct(product: 현재 페이지 들어올떄 받았던 productEntity, num: 갯수);
                    viewModelFC.addProduct(
                      product: product,
                      num: productNum.value,
                    );
                    Navigator.pop(context);
                    showConfirmationDialog();
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
      );
    }

    // 총 가격 계산
    final double totalPrice = product.price * productNum.value;
    final String formattedPrice = formatter.format(product.price);
    final String formattedTotal = formatter.format(totalPrice);

    return Scaffold(
      // 앱바: 뒤로가기 + 상품명
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // 본문
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상품 이미지
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  // 제품별 이미지 URL
                  _getProductImage(product.name),
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Image loading error: $error'); // 디버깅용
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red[700],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '이미지를 불러올 수 없습니다',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '잠시 후 다시 시도해주세요',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 상품명과 가격
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('$formattedPrice 원', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),

            // 상품 설명
            const Text(
              '상품 설명',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getProductDescription(product.name),
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),

      // 하단 구매 영역
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            // 수량 조절
            IconButton(
              onPressed: () => updateProductNum(false),
              icon: const Icon(Icons.remove),
            ),
            Text(
              productNum.value.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              onPressed: () => updateProductNum(true),
              icon: const Icon(Icons.add),
            ),
            const Spacer(),

            // 가격 정보
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('총 가격', style: TextStyle(fontSize: 14)),
                Text(
                  '$formattedTotal 원',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),

            // 구매 버튼
            ElevatedButton(
              onPressed: showPurchaseDialog,
              child: const Text('구매하기'),
            ),
          ],
        ),
      ),
    );
  }

  // 제품별 상세 설명을 반환하는 메서드
  String _getProductDescription(String productName) {
    switch (productName.toLowerCase()) {
      case '자전거':
        return '''[제품 사양]
• 프레임: 고강도 알루미늄 6061 합금
• 변속 시스템: 시마노 DEORE XT 30단
• 브레이크: 유압식 디스크 브레이크
• 타이어: 슈발베 마라톤 700x35C
• 무게: 약 11.5kg
• 권장 신장: 165cm ~ 180cm

[주요 특징]
• 도심 주행과 장거리 라이딩 모두에 최적화된 하이브리드 설계
• 충격 흡수력이 뛰어난 카본 포크 적용
• 인체공학적 설계로 장시간 라이딩에도 편안한 착좌감
• 우천시에도 강력한 제동력을 발휘하는 디스크 브레이크
• 야간 주행을 위한 반사 스트립 장착
• 경량 알루미늄 프레임으로 운반과 보관이 용이
• 내구성 높은 더블 월 림 적용

[성능 및 주행 특성]
• 변속 성능: 
  - 시마노 DEORE XT 30단 변속 시스템
  - 부드러운 기어 변경과 정확한 변속감
  - 넓은 기어비로 다양한 주행 환경 대응
• 제동 성능:
  - 유압식 디스크 브레이크 시스템
  - 우천시에도 안정적인 제동력
  - 브레이크 레버 조절 가능
• 주행 성능:
  - 공기역학적 프레임 설계
  - 효율적인 페달링 전달력
  - 진동 흡수 설계로 편안한 승차감

[구매 혜택]
• 전문 기술자의 완벽한 조립 및 점검
• 구매일로부터 1년간 무상 점검 서비스
• 주요 부품 2년 품질 보증
• 사이즈 교환 1회 무상 지원
• 구매 후 2주 이내 반품/교환 가능

[유지관리 안내]
• 정기적인 체인 오일 주유 권장
• 3개월마다 전문가 점검 추천
• 타이어 공기압 정기 점검 필요
• 우천시 주행 후 세심한 관리 필요

[안전 주의사항]
• 주행 전 안전모 착용 필수
• 야간 주행 시 전조등과 후미등 사용
• 정기적인 브레이크 패드 마모도 체크
• 음주 운전 절대 금지

[패키지 구성]
• 완조립 자전거
• 기본 공구 세트
• 사용자 매뉴얼
• 반사경 및 벨
• 물통 거치대

※ 매장 방문 시 전문가의 상담을 통해 신체 사이즈에 맞는 프레임을 선택하실 수 있습니다.
※ 부품 재고 상황에 따라 동급 사양으로 변경될 수 있습니다.
※ 자전거 조립 및 점검에 1-2일이 소요될 수 있습니다.''';

      case '맥북':
        return '''[제품 사양]
• 디스플레이: 14.2인치 Liquid Retina XDR 디스플레이 (3024 x 1964)
• 프로세서: Apple M2 Pro 칩 (12코어 CPU, 19코어 GPU)
• 메모리: 16GB 통합 메모리
• 저장 용량: 512GB SSD
• 배터리: 최대 18시간 사용 가능
• 무게: 1.6kg

[성능 및 처리 능력]
• CPU 성능:
  - 12코어 CPU (8 성능 코어 + 4 효율 코어)
  - 최대 4.8GHz 클럭 속도
  - 16MB L2 캐시
• GPU 성능:
  - 19코어 GPU
  - 최대 38.4GB/s 메모리 대역폭
  - ProRes 가속 엔진 내장
• 신경망 엔진:
  - 16코어 Neural Engine
  - 초당 15.8조 연산 처리
  - 머신 러닝 가속기

[디스플레이 성능]
• 최대 밝기: 1600 니트 (HDR)
• 기본 밝기: 500 니트
• ProMotion 기술 (120Hz)
• True Tone 기술
• P3 넓은 색영역
• 10억 색상 표현
• 1,000,000:1 명암비

[연결성]
• Thunderbolt 4 포트 3개
  - 최대 40Gb/s 데이터 전송
  - DisplayPort 지원
  - USB 4 지원
• HDMI 포트
  - 최대 8K 외부 디스플레이 지원
• SDXC 카드 슬롯
• MagSafe 3 충전 포트
• Wi-Fi 6E (802.11ax)
• Bluetooth 5.3

[오디오 시스템]
• 6 스피커 시스템
  - 포스 캔슬링 우퍼
  - 광역 스테레오
• 스튜디오급 3개 마이크 어레이
• 공간 음향 지원
• 돌비 애트모스 지원

[보안 기능]
• Apple T2 보안 칩
• Touch ID 센서
• 보안 부팅
• 런타임 안티 멀웨어
• 암호화 저장소

[카메라 및 영상]
• 1080p FaceTime HD 카메라
• ISP 고급 이미지 신호 처리
• 컴퓨테이셔널 비디오 처리
• 스튜디오 품질 마이크

[구매 혜택]
• 무료 각인 서비스
• 교육 할인 가능
• Apple Care+ 가입 시 3년 보증
• 무료 기술 지원 (90일)
• 14일 이내 반품 가능
• 무료 배송 서비스

[패키지 구성]
• MacBook Pro 14
• 67W USB-C 전원 어댑터
• USB-C to MagSafe 3 케이블
• 사용자 설명서
• 스티커 팩

[AS 및 지원]
• 1년 제한 보증
• 90일 무료 기술 지원
• Apple Store 및 공인 서비스 센터에서 서비스 제공
• Apple Care+ 선택 시 추가 혜택
• 전문가 1:1 지원

[환경 친화적 특징]
• 100% 재활용 알루미늄 인클로저
• 무수은, BFR/PVC 미사용
• 에너지 스타 인증
• EPEAT Gold 등급

※ 실제 배터리 사용 시간은 사용 패턴과 설정에 따라 다를 수 있습니다.
※ 제품 사양은 출시 국가와 지역에 따라 다를 수 있습니다.
※ 일부 기능은 인터넷 연결이 필요합니다.
※ 성능은 시스템 구성과 사용 환경에 따라 달라질 수 있습니다.''';

      case '아이폰 16 pro max':
        return '''[제품 사양]
• 디스플레이: 6.7인치 Super Retina XDR OLED (2796 x 1290)
• 프로세서: A17 Pro 칩 (6코어 CPU, 6코어 GPU, 16코어 Neural Engine)
• 저장 용량: 256GB NVMe 스토리지
• RAM: 8GB LPDDR5
• 카메라: 
  - 메인: 48MP (f/1.78, OIS, 센서시프트)
  - 울트라 와이드: 12MP (f/2.2, 120° 화각)
  - 망원: 12MP (f/2.8, 5x 광학 줌, OIS)
• 전면 카메라: 12MP TrueDepth (f/1.9, 자동초점)
• 배터리: 4422mAh, 최대 29시간 비디오 재생

[성능 및 처리 능력]
• CPU 성능: 최대 10% 향상 (전작 대비)
• GPU 성능: 최대 20% 향상
• 신경망 처리: 초당 18조 회 연산 처리
• 게임 성능: 콘솔급 레이 트레이싱 지원
• 전력 효율: 향상된 성능 코어와 효율 코어 밸런싱

[카메라 성능]
• 메인 카메라:
  - 픽셀 바이닝으로 1200만 화소 이미지 생성
  - 2μm 대형 픽셀 크기로 저조도 성능 향상
  - 스마트 HDR 5 지원
• 망원 카메라:
  - 120mm 초점 거리 (35mm 환산)
  - 매크로 촬영 지원 (최소 초점 거리 5cm)
• 비디오 촬영:
  - 4K ProRes 60fps 녹화
  - 10-bit HDR 지원
  - 액션 모드 손떨림 보정

[디스플레이 성능]
• 최대 밝기: 2000 니트 (야외)
• 색 영역: DCI-P3 100%
• HDR 표현력: 10억 컬러
• 터치 응답 속도: 120Hz
• True Tone 기술

[보안 및 성능]
• Face ID 응답 속도 20% 향상
• 온디바이스 AI 처리 강화
• 향상된 개인정보 보호 기능
• 보안 엔클레이브 프로세서

[연결성 및 네트워크]
• 5G 모뎀: 최대 7.5Gbps
• Wi-Fi 6E: 최대 2.4Gbps
• 블루투스 5.3
• UWB 2세대 칩
• NFC 리더기 모드

※ 실제 성능은 사용 환경과 설정에 따라 다를 수 있습니다.
※ 배터리 성능은 네트워크 환경과 사용 패턴에 따라 달라질 수 있습니다.
※ 일부 고급 카메라 기능은 A17 Pro 칩의 성능이 필요합니다.''';

      case '갤럭시 s25':
        return '''[제품 사양]
• 디스플레이: 6.8인치 Dynamic AMOLED 2X (3088 x 1440)
• 프로세서: Snapdragon 8 Gen 3 (4nm)
  - 1x 3.39GHz (Prime)
  - 3x 3.1GHz (Performance)
  - 4x 2.9GHz (Efficiency)
• RAM: 12GB LPDDR5X (8448Mbps)
• 저장 용량: 256GB UFS 4.0
• 카메라:
  - 메인: 200MP (f/1.7, OIS)
  - 울트라 와이드: 12MP (f/2.2)
  - 망원: 50MP (f/3.4, 5x 광학 줌)
• 전면 카메라: 12MP (f/2.2, 자동초점)
• 배터리: 5000mAh

[성능 및 처리 능력]
• CPU 성능: 최대 30% 향상 (전작 대비)
• GPU 성능: 최대 25% 향상
• NPU 성능: 최대 50% 향상
• 메모리 처리 속도: 8448Mbps
• 저장장치 속도: 읽기 4200MB/s, 쓰기 2800MB/s

[AI 성능]
• 실시간 번역 및 통역
• AI 기반 이미지 처리
• 지능형 성능 최적화
• 신경망 처리 장치 강화
• 온디바이스 AI 처리 향상

[게이밍 성능]
• 레이 트레이싱 지원
• 게임 프레임 보정
• 터치 응답 속도 향상
• 게임 부스터 2.0
• 증강현실 게임 최적화

[디스플레이 성능]
• 최대 밝기: 2600 니트
• 응답 속도: 1ms
• 가변 주사율: 1-120Hz
• HDR10+ 인증
• 색 정확도: DCI-P3 100%

[카메라 시스템 성능]
• 메인 카메라:
  - 어댑티브 픽셀 센서
  - 향상된 나이토그래피
  - AI 기반 이미지 처리
• 망원 카메라:
  - 공간 줌 AI 보정
  - 초정밀 손떨림 보정
• 비디오 성능:
  - 8K 30fps 녹화
  - 4K 120fps 지원
  - HDR10+ 비디오

[보안 성능]
• Knox Vault 보안 프로세서
• 실시간 위협 감지
• 보안 폴더 2.0
• 향상된 생체 인증
• 암호화 성능 강화

※ AI 성능은 학습 데이터와 사용 환경에 따라 차이가 있을 수 있습니다.
※ 게임 성능은 게임 타이틀에 따라 다르게 나타날 수 있습니다.
※ 실제 배터리 성능은 네트워크 환경과 사용자 패턴에 따라 달라질 수 있습니다.''';

      case '에어팟 프로':
        return '''[제품 사양]
• 모델: AirPods Pro (2세대)
• 칩셋: H2 칩 (고급 오디오 처리)
• 배터리:
  - 이어버드: 최대 6시간 (ANC 켰을 때)
  - 충전 케이스: 총 30시간
• 충전: MagSafe, 무선 충전, USB-C
• 방수/방진: IPX4 등급
• 무게: 
  - 이어버드: 각 5.3g
  - 충전 케이스: 45.6g

[오디오 성능]
• 드라이버 구성:
  - 고성능 커스텀 드라이버
  - 고진폭 앰프
  - 고동적 범위 증폭기
• 주파수 응답: 20Hz-20kHz
• 음압 레벨: 최대 106dB
• 왜곡률: 0.1% 미만

[노이즈 캔슬링 성능]
• ANC 소음 감소: 최대 -36dB
• 적응형 EQ 처리 속도: 48,000회/초
• 외부 소음 모니터링: 실시간 분석
• 주변음 감지 모드: 자연스러운 음성 전달
• 개인 맞춤형 공간 음향:
  - 동적 머리 추적
  - 개인화된 HRTF 프로필
  - 실시간 공간 렌더링

[연결 성능]
• 블루투스 5.3
• 지연 시간: 5ms 미만
• 연결 범위: 최대 10m
• 자동 기기 전환 속도: 1초 이내
• 멀티포인트 연결 지원

[배터리 성능]
• 고속 충전: 5분 충전 = 1시간 사용
• 배터리 수명: 
  - ANC 켰을 때: 6시간
  - ANC 껐을 때: 7시간
• 충전 케이스 충전 시간: 
  - 유선: 약 1시간
  - 무선: 약 2시간

[프로세싱 성능]
• H2 칩 성능:
  - 10코어 오디오 프로세서
  - 실시간 적응형 EQ
  - 공간 음향 렌더링
  - 노이즈 캔슬링 최적화

[센서 성능]
• 듀얼 광학 센서
• 모션 감지 가속도계
• 음성 감지 가속도계
• 압력 감지 센서
• 피부 감지 센서

※ 배터리 성능은 사용 환경과 설정에 따라 달라질 수 있습니다.
※ 노이즈 캔슬링 성능은 주변 환경에 따라 차이가 있을 수 있습니다.
※ 공간 음향은 지원되는 기기에서만 사용 가능합니다.''';

      default:
        return '''[제품 사양]
• 자세한 제품 정보는 준비 중입니다.
• 구매 전 매장에서 상담을 받아보세요.

[AS 및 지원]
• 1년 제품 보증
• 전국 서비스 센터에서 서비스 제공

※ 자세한 내용은 고객센터로 문의해 주세요.''';
    }
  }

  // 제품별 이미지 URL을 반환하는 메서드
  String _getProductImage(String productName) {
    switch (productName.toLowerCase()) {
      case '자전거':
        return 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?auto=format&fit=crop&w=800&q=80';
      case '맥북':
        return 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=1000&q=80';
      case '아이폰 16 pro max':
        return 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=1000&q=80';
      case '갤럭시 s25':
        return 'https://images.unsplash.com/photo-1678911820864-e2c567c655d7?auto=format&fit=crop&w=1000&q=80';
      case '에어팟 프로':
        return 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=1000&q=80';
      default:
        return 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?auto=format&fit=crop&w=800&q=80';
    }
  }
}
