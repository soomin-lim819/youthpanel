** 2020년도 **

use "/Users/cheyeong/Desktop/YP_Research/yp2021_STATA/YP2007_STATA_raw/YP01-14/yp01-14(2007)/ypdata_w14.dta"


** 참여여부 확인 // 참여: 6,791, 미참여: 3,415
tab w14

** 웅답자 유형 // 대학생: 53, 대학원생: 51, 취업자: 5,234, 미취업자: 1,453
tab w14type

** 조사연도 year
gen year = date14_y

** 조사월 month
gen month = date14_m

** 성별 gender // 여자 = 0, 남자 = 1
*replace gender = 0 if gender == 2

** 나이 age (출생년도 = yob)

* gen age = 조사년도 - 출생년도
* replace age = year - yob
gen age = year - yob

** 최종학력 edu
replace w14edu = 0 if w14edu == 9090908
replace w14edu = 0 if w14edu == 9090909

gen edu = w14edu



** 거주지역-수도권 여부 capital

gen capital = .

* 수도권을 1로 설정
replace capital = 1 if w14region == 1 | w14region == 4 | w14region == 8

* 비수도권 및 기타를 0으로 설정
replace capital = 0 if w14region == 2 | w14region == 3 | w14region == 5 | w14region == 6 | w14region == 7 | (w14region >= 9 & w14region <= 17) | w14region == 97

label define capital_lbl 1 "수도권" 0 "비수도권"
label values capital capital_lbl

** 긱워커 gig

*현직장 현재 종사상 지위 // 취업자: 5,234명, 전체: 10,206
fre y14b161
replace y14b161 = 0 if missing(y14b161)

*gig변수 생성

gen gig = .

replace gig = 1 if y14b161 == 2 & y14b163 <=2 | y14b161 == 3 & y14b163 <=2 // 1년 미만 계약된 임시/일용근로자

replace gig = 2 if y14b161 == 5 // 1인 자영업

replace gig = 3 if y14b161 == 1 & y14b224 == 5 | y14b161 == 1 & y14b224 == 4 | y14b161 == 1 & y14b224 == 3
//상용근로자이면서 주급, 일급, 시급을 받는 동시일자리 보유자

** 비임금 근로자 추가
*tab y14b313 // 비임금 근로자 수 확인
*tab y14b314 // 비임금 근로 - 고용 종업원 수(본인 제외) = 0 // 352명

*replace gig = 4 if y14b314 == 0
*replace gig = 0 if missing(gig)

*gen gigreal = .
*replace gigreal = cond(gig != 4, gig, .)

* labeling
* label drop giglabel

label define giglabel 0 "Non-gig" 1 "1년미만임시일용" 2 " 1인자영업자" 3 "상용일자리시간제경험자"
label values gig giglabel


tab y14b161 gig if y14b161 !=0 //

***non-gig 중 상용일자리, 비경활인구, 고용원이있는self-employed, 무급가족종사자, 임시직/일용직 1년이상 제외
gen nongigreal=1
replace nongigreal = 0 if y14b161==1 | y14b161==4 | y14b161==6
replace nongigreal =0 if y14b163 >3
replace nongigreal =0 if y14b784 == 2


**상용일자리 변수 추가
gen permanent =.
replace permanent if y14b161=1


** 거주지역 - 광역시 여부 metropolitan
gen metropolitan = .

* 광역시를 1로 설정
replace metropolitan = 1 if inlist(w14region, 1, 2, 3, 4, 5, 6, 7)

* 비광역시를 0으로 설정
replace metropolitan = 0 if w14region >= 8 & w14region <= 17 | w14region == 97

label define metro_lbl 1 "광역시" 0 "비광역시"
label values metropolitan metro_lbl

** 총가구원수 fammem
replace y14g407 = 0 if y14g407 == 9090908
replace y14g407 = 0 if y14g407 == 9090909

gen fammem = y14g407

** 취업가구원수 empfammem
replace y14g499 = 0 if y14g499 == 9090908
replace y14g499 = 0 if y14g499 == 9090909

gen empfammem = y14g499

** 자녀유무 kid
replace y14g500 = 0 if y14g500 == 9090908
replace y14g500 = 0 if y14g500 == 9090909

gen kid = y14g500

** 자녀수 numkid
replace y14g501 = 0 if y14g501 == 9090908
replace y14g501 = 0 if y14g501 == 9090909

gen numkid = y14g501

** 가구주 household
replace y14g502 = 5 if inlist(y14g502, 5, 6, 7, 8, 9, 10, 97)
label define y14g502_lbl 5 "기타", modify

label values y14g502 y14g502_lbl

replace y14g502 = 0 if y14g502 == 9090908
replace y14g502 = 0 if y14g502 == 9090909

gen household = y14g502

** 주택종류 housetype
replace y14g605 = 0 if y14g605 == 9090908
replace y14g605 = 0 if y14g605 == 9090909

gen housetype = y14g605

** 고등학교유형 highscl (9차 이후부터 달라서 확인할 것)

** 1-8차 highscl

* 9090908과 9090909를 0으로 변경
*replace y03a030 = 0 if y03a030 == 9090908
*replace y03a030 = 0 if y03a030 == 9090909

*replace y03a030 = 3 if y03a030 >= 3 & y03a030 <= 5
*replace y03a030 = 4 if y03a030 == 6
*replace y03a030 = 5 if y03a030 == 7

*gen highscl = y03a030


** 9차 ~

* 9090908과 9090909를 0으로 변경
*replace y**a030 = 0 if y**a030 == 9090908
*replace y**a030 = 0 if y**a030 == 9090909

* 1이면 1로 유지 (변경 필요 없음)
* 2이면 2로 유지 (변경 필요 없음)

*replace y**a030 = 3 if inlist(y**a030, 3, 4, 5, 6, 8)
*replace y**a030 = 4 if y**a030 == 7
*replace y**a030 = 5 if y**a030 == 9

*gen highscl = y**a030


*gen highscl = y14a030

** 대학교유형 unitype
*replace y14a031 = 8 if inlist(y14a031, 97)
*replace y14a031 = 0 if y14a031 == 9090908
*replace y14a031 = 0 if y14a031 == 9090909

*gen unitype = y14a031

** 전공계열 major
*replace y14a034 = 9 if inlist(y14a034, 97)
*replace y14a034 = 0 if y14a034 == 9090908
*replace y14a034 = 0 if y14a034 == 9090909

*gen major = y14a034

** 산업코드 industry
*replace y14b153z = 3 if inlist(y14b153z, 4, 5, 6)
*replace y14b153z = 4 if inrange(y14b153z, 7, 19)
*replace y14b153z = 5 if inlist(y14b153z, 20, 21)


*label define y14b153z_lbl 3 "제조업" 4 "서비스업" 5 "기타"
*label values y14b153z y14b153z_lbl

*gen industry = y14b153z

** 사회보험 부가급여 empinsur
replace y14b207 = 0 if y14b207 == 9090908
replace y14b207 = 0 if y14b207 == 9090909

gen empinsur = y14b207

** 부채유무 debtyes
replace y14b226 = 0 if y14b226 == 9090908
replace y14b226 = 0 if y14b226 == 9090909

gen debtyes = y14b226

** 부채금액 debt
gen debt = y14b227

** 실업급여 수령 여부
replace y14b351 = 0 if y14b351 == 9090908
replace y14b351 = 0 if y14b351 == 9090909

gen unemplbyes = y14b351

* 실업급여 월 수령 금액(원)
gen unemplb = y14b352

* 실업급여 수령 기간(일)
gen unemplbd = y14b353

* 플랫폼노동자
replace y14c201 = 0 if y14c201 == 9090908
replace y14c201 = 0 if y14c201 == 9090909

gen platform = y14c201

** 부모님과 동거여부 // 5차 이후로 변수 추가됨 확인할 것
replace y14g401 = 2 if y14g401 == 3
replace y14g401 = 0 if y14g401 == 9090908
replace y14g401 = 0 if y14g401 == 9090909

gen parent = y14g401







*라벨링하기


**edu (최종학력)
label define edulabel 1 "고졸미만" 2 "고졸" 3 "전문대졸" 4 "대졸" 5 "석사학위이상"
label value edu edulabel

**kid(자녀여부)
label define kidlabel 1 "예" 2 "아니오"
label value kid kidlabel

**household(세대주여부)
label define householdlabel 1 "가구주 본인" 2 "가구주의 배우자" 3 "가구주의 자녀" 4 "가구주의형제/자매 " 5 "기타"
label value household householdlabel

**housetype(주택형태)
label define housetypelabel 1 "단독주택" 2 "아파트" 3 "연립주택이나 빌라" 4 "다세대/다가구 주택" 5 "오피스텔" 6 "상가건물" 7 "기타"
label value housetype housetypelabel


**highscl(고등학교유형)
*label define highscllabel 1 "일반계/인문계(종합고 인문계포함)" 2"특목고(과학고,외고,자사고)" 3 "상업/공업/전문/마이스터" 4 "예체능" 5 "기타(대안학교,해외고교,방송통신고 등)"
*label value highscl highscllabel

**unitype(대학교유형)
*label define unitypelabel 1 "일반 4년제 대학" 2 "2~3년제 대학" 3 "산업대학" 4 "교육대학" 5 "방송통신대학" 6 "사이버(디지털)대학" 7 "기능대학(폴리텍)" 8 "기타"
*label value unitype unitypelabel

**major(전공계열)
*label define majorlabel 1 "농업, 임업 및 어업, 광업" 2"사회/상경계열" 3 "자연계열" 4 "공학계열" 5 "의/약학계열" 6 "교육계열" 7 "예체능계열" 8"사관학교/경찰대" 9"기타"
*label value major majorlabel

**industry(산업코드대분류)
*recode industry (3=2) (4=3) (5=4)
*label define industrylabel 1 "농업, 임업 및 어업, 광업" 2"제조업" 3 "서비스업" 4 "기타"
*label value industry industrylabel

**empinsur(실업급여수령여부)
label define empisurlabel 1 "예" 2 "아니오"
label value empinsur empinsurlabel

**debtyes(부채유무)
label define debtyeslabel 1 "예" 2 "아니오"
label value debtyes empinsurlabel


**unemplbyes / 실업급여수령여부
label define unemplbyeslabel 1 "예" 2 "아니오"
label value unemplbyes unemplbyeslabel

**platform/ 플랫폼노동자여
label define platformlabel 1 "예" 2 "아니오"
label value platform platformlabel

**parent / 부모님과동거여부
label define parentlabel 1 "예" 2 "아니오"
label value parent platformlabel






**Job Priority
*Achievement / 성취
gen jobpri_achievement=1 if y14b108 <= 2
replace jobpri_achievement=2 if y14b108 ==3
replace jobpri_achievement =3 if y14b108 == 4 | y14b108 == 5
replace jobpri_achievement =4 if y14b108 == 9090908 |y14b108 == 9090909

label define jobprilabel 1 "Not Important" 2 "Neutral" 3 "Important" 4 "Not answered"
label value jobpri_achievement jobprilabel


*Egalitarianism / 이타
gen jobpri_egal=1 if y14b109 <= 2
replace jobpri_egal =2 if y14b109 ==3
replace jobpri_egal =3 if y14b109 == 4 | y14b109 == 5
replace jobpri_egal =4 if y14b109 == 9090908 |y14b109 == 9090909

label value jobpri_egal jobprilabel


*Preference / 개인지향
gen jobpri_prefer=1 if y14b110 <= 2
replace jobpri_prefer =2 if y14b110 ==3
replace jobpri_prefer =3 if y14b110 == 4 | y14b110 == 5
replace jobpri_prefer =4 if y14b110 == 9090908 |y14b110 == 9090909

label value jobpri_prefer jobprilabel


*Reward / 경제적보상
gen jobpri_reward=1 if y14b111 <= 2
replace jobpri_reward =2 if y14b111 ==3
replace jobpri_reward =3 if y14b111 == 4 | y14b111 == 5
replace jobpri_reward =4 if y14b111 == 9090908 |y14b111 == 9090909

label value jobpri_reward jobprilabel


*Reward / 인정
gen jobpri_acknow=1 if y14b112 <= 2
replace jobpri_acknow =2 if y14b112 ==3
replace jobpri_acknow =3 if y14b112 == 4 | y14b112 == 5
replace jobpri_acknow =4 if y14b112 == 9090908 |y14b112 == 9090909

label value jobpri_acknow jobprilabel

*body / 신체활동
gen jobpri_body=1 if y14b113 <= 2
replace jobpri_body =2 if y14b113 ==3
replace jobpri_body =3 if y14b113 == 4 | y14b113 == 5
replace jobpri_body =4 if y14b113 == 9090908 |y14b113 == 9090909

label value jobpri_body jobprilabel

*stability / 직업안정
gen jobpri_stability=1 if y14b114 <= 2
replace jobpri_stability =2 if y14b114 ==3
replace jobpri_stability =3 if y14b114 == 4 | y14b114 == 5
replace jobpri_stability =4 if y14b114 == 9090908 |y14b114 == 9090909

label value jobpri_stability jobprilabel


*diversity / 다양
gen jobpri_diversity=1 if y14b115 <= 2
replace jobpri_diversity =2 if y14b115 ==3
replace jobpri_diversity =3 if y14b115 == 4 | y14b115 == 5
replace jobpri_diversity =4 if y14b115 == 9090908 |y14b115 == 9090909

label value jobpri_diversity jobprilabel


*hi / 심신의안녕
gen jobpri_hi=1 if y14b116 <= 2
replace jobpri_hi =2 if y14b116 ==3
replace jobpri_hi =3 if y14b116 == 4 | y14b116 == 5
replace jobpri_hi =4 if y14b116 == 9090908 |y14b116 == 9090909

label value jobpri_diversity jobprilabel

*influence / 타인의영향
gen jobpri_influ=1 if y14b117 <= 2
replace jobpri_influ =2 if y14b117 ==3
replace jobpri_influ =3 if y14b117 == 4 | y14b117 == 5
replace jobpri_influ =4 if y14b117 == 9090908 |y14b117 == 9090909

label value jobpri_influ jobprilabel

*know / 지적추구
gen jobpri_know=1 if y14b118 <= 2
replace jobpri_know =2 if y14b118 ==3
replace jobpri_know =3 if y14b118 == 4 | y14b118 == 5
replace jobpri_know =4 if y14b118 == 9090908 |y14b118 == 9090909

label value jobpri_know jobprilabel

*patriotism / 애국
gen jobpri_patri=1 if y14b118 <= 2
replace jobpri_patri =2 if y14b119 ==3
replace jobpri_patri =3 if y14b119 == 4 | y14b119 == 5
replace jobpri_patri =4 if y14b119 == 9090908 |y14b119 == 9090909

label value jobpri_patri jobprilabel

*autonomy / 자율
gen jobpri_auto=1 if y14b119 <= 2
replace jobpri_auto =2 if y14b120 ==3
replace jobpri_auto =3 if y14b120 == 4 | y14b120 == 5
replace jobpri_auto =4 if y14b120 == 9090908 |y14b120 == 9090909

label value jobpri_auto jobprilabel



***
* indcode 산업코드 대분류 y**b153z / y**b507z(동시일자리1) y**b532z(동시일자리2) y**b557z(동시일자리3)


gen indcode = y14b153z

** jobcode 직업코드 대분류 y**b156z


gen jobcode = y14b156z


** joblocc 현직장 소재지(수도권) y**b157z

gen joblocc = .

* 수도권을 1로 설정
replace joblocc = 1 if y14b157z == 1 | y14b157z == 4 | y14b157z == 8

* 비수도권 및 기타를 0으로 설정
replace joblocc = 0 if y14b157z == 2 | y14b157z == 3 | y14b157z == 5 | y14b157z == 6 | y14b157z == 7 | (y14b157z >= 9 & y14b157z <= 17) | y14b157z == 97

label define joblocc_lbl 1 "수도권" 0 "비수도권"
label values joblocc joblocc_lbl

** 현직장 소지 - 광역시 여부 joblocm
gen joblocm = .

* 광역시를 1로 설정
replace joblocm = 1 if inlist(y14b157z, 1, 2, 3, 4, 5, 6, 7)

* 비광역시를 0으로 설정
replace joblocm = 0 if y14b157z >= 8 & y14b157z <= 17 | y14b157z == 97

label define joblocm 1 "광역시" 0 "비광역시"
label values joblocm joblocm_lbl


** 회사유형 corptype y**b158

* 1-8차 조사
gen corptype = .

replace corptype = 1 if inlist(y14b158, 1,2)
replace corptype = 2 if inlist(y14b158, 3,5)
replace corptype = 3 if inlist(y14b158, 4)
replace corptype = 4 if y14b158 == 6
replace corptype = 5 if inlist(y14b158, 97)
replace corptype = 0 if inlist(y14b158, 9090908, 9090909)


* 9차 이후
gen corptype = .

replace corptype = 1 if inlist(y14b158, 1,2)
replace corptype = 2 if inlist(y14b158, 3,5)
replace corptype = 3 if inlist(y14b158, 4,6)
replace corptype = 4 if y14b158 == 7
replace corptype = 5 if inlist(y14b158, 97)
replace corptype = 0 if inlist(y14b158, 9090908, 9090909)

** tempjob 현재 정규직 비정규직 여부 (7차) y**b308

replace y14b308 =0 if y14b308 == 9090908 |y14b308 == 9090909
gen tempjob = y14b308

** y**b399 현재 고용형태 근무 이유 (14차) whywork
replace y14b399 = 11 if y14b399 == 97
replace y14b399 = 0 if y14b399 == 9090908 |y14b399 == 9090909
gen whywork = y14b399

** 비정규직 근무 이유 y**b215 tempwhy (2차에만)
*replace y14b215 = 0 if y14b215 == 9090908 |y14b215 == 9090909
*gen tempwhy = y14b215

** 비정규직 근무 희망 이유 whywanttemp (2차에만) y**b216
*replace y14b216 = 7 if y14b216 == 97
*replace y14b216 = 0 if y14b216 == 9090908 |y14b216 == 9090909
*gen whywanttemp = y14b216

** 현직장 노조여부 unionyes y**b276
replace y14b276 = 0 if y14b276 == 9090908 |y14b276 == 9090909
gen unionyes = y14b276

** 노조 가입여부 unionreg y**b277

replace y14b277 = 0 if y14b277 == 9090908 |y14b277 == 9090909
gen unionreg = y14b277

** 실업자/비경제활동인구 구분 unemp y**b784
gen unemp = y14b784

** 직업훈련참여여부 ojt y**ojt
replace y14ojt = 1 if y14ojt == 0
replace y14ojt = 2 if y14ojt == 1
replace y14ojt = 0 if y14ojt == 9090908 | y14ojt == 9090909

gen ojt = y14ojt

** 현재혼인상태 married y**g101
replace y14g101 = 0 if y14g101 == 9090908 | y14g101 == 9090909
gen married = y14g101

** 아버지 최종학력 fatheredu y**g008 (1차/9차에만)
replace y14g008 = 0 if y14g008 == 9090908 | y14g008 == 9090909
gen fatheredu = y14g008

** 어머니 최종학력 motheredu y**g010 (1차/9차에만)
replace y14g010 = 0 if y14g010 == 9090908 | y14g010 == 9090909
gen motheredu = y14g010

** 배우자월평균소득 spousewage y**g115(2차)
replace y14g115 = 0 if y14g115 == 9090908 | y14g115 == 9090909
gen spousewage = y14g115

** 배우자종사장지위 spousestat y**g114 (2차)
replace y14g114 = 0 if y14g114 == 9090908 | y14g114 == 9090909
gen spousestat = y14g114

** 현재 아버지 종사장지위 fatherstat y**g302
replace y14g302 = 0 if y14g302 == 9090908 | y14g302 == 9090909
gen fatherstat = y14g302

** 현재 어머니 종사장지위 motherstat y**g304
replace y14g304 = 0 if y14g304 == 9090908 | y14g304 == 9090909
gen motherstat = y14g304

** 응답자 유형
gen type = w14type

** 횡단면 가중치
weight**_c

** 종단면 가중치
weight**_l

*****


** 고등학교 학교계열 1차, 9차
y**a316


** 1번째 대학 전공계열 1차, 9차에만

y**a329

* 대학유형
y**a333

* 2번째 대학교
y**a343 / y**a347

* 대학원 전공 y**a358
* 대학원 학위과정 y**a360


** 재학 중 취업자 근로형태 y**b005

/** 임금 (임금근로자의 경우)
임금단위 y**b224
현직장임금 y**b225
정규근로시간 y**b220
초과근로시간 y**b221
정규근로일수 y**b222
초관근로일수 y**b223


연봉 - 월평균: 연봉/12
월평균 - 월평균: 월평균 임금
주당 - 월평균: 주당 임금 * 4.3
일당 - 월평균: 일당 임금 * (주당 정규근로일수 + 주당 초과근로일수) * 4.3
시간당 - 월평균: 시간당 임금 * (주당 정규근로시간 + 주당 초과근로시간) * 4.3



* 월급 변수 생성 (단위: 만원)
gen WAGE = .
replace WAGE = (y14b225 / 12) if y14b224 == 1 // 연봉/12 = 월급
replace WAGE = y14b225 if y14b224 == 2 // 월급
replace WAGE = (y14b225 * 4.3) if y14b224 == 3 // 주급 * 4.3 = 월급
replace WAGE = y14b225 * (y14b222 + y14b223) * 4.3 if y14b224 == 4 // 일급 * (주당정규근로일수 + 주당 초과근로일수) * 4.3 = 월급
replace WAGE = y14b225 * (y14b220 + y14b221) * 4.3 if y14b224 == 5 // 시급 * 주당근로시간 * 4.3 = 월급

replace WAGE = 0 if WAGE == 9090908 | WAGE == 9090909


* 자영업자 = 비임금근로자
보험, 매출액이 총 수입은 아님. 어떻게 할지 생각해봐야 함.

*동시일자리 임금 급여 형태에 따른 변수 생성(단위: 만원) 아래 수정 필요함

gen annwage_side = Ba50b if Ba50a == 1 //연봉
gen monwage_side = Ba50b if Ba50a == 2 //월급
gen weekwage_side = Ba50b if Ba50a == 3 //주급
gen daywage_side = Ba50b if Ba50a == 4 //일급
gen hourwage_side = Ba50b if Ba50a == 5 //시급

*동시일자리 월급 변수 생성(단위: 만원)
gen WAGE_s = (Ba50b/12) if Ba50a == 1 //연봉 /12 = 월급
replace WAGE_s = Ba50b if Ba50a == 2 //월급
replace WAGE_s = (Ba50b*4.345) if Ba50a == 3 //주급*4.345주 = 월급
replace WAGE_s = (Ba50b*Ba49a*4.345) if Ba50a == 4 //일급 *근로일수*4.345주 =월급
replace WAGE_s = (Ba50b*Ba48a*4.345) if Ba50a == 5 //시급*주당근로시간*4.345주 = 월급

*현직장+동시일자리 임금 급여 형태에 따른 변수 생성
egen annwage_tot = rowtotal(annwage_now annwage_side)
egen monwage_tot = rowtotal(monwage_now monwage_side)
egen weekwage_tot = rowtotal(weekwage_now weekwage_side)
egen daywage_tot = rowtotal(daywage_now daywage_side)
egen hourwage_tot = rowtotal(hourwage_now hourwage_side)

*현직장+동시일자리 총 월급 변수 생성
egen monWAGE = rowtotal(WAGE WAGE_s)


*///


** append용 (platform은 14차에만)

rename gemmem fammem


gen type = w14type

keep year month age edu capital gig nongigreal permanent metropolitan fammem empfammem kid numkid household housetype empinsur debtyes debt unemplbyes unemplb unemplbd platform parent jobpri_achievement jobpri_egal jobpri_prefer jobpri_reward jobpri_acknow jobpri_body jobpri_stability jobpri_diversity jobpri_hi jobpri_influ jobpri_know jobpri_patri jobpri_auto indcode jobcode joblocc joblocm corptype tempjob whywork unionyes unionreg unemp ojt married spousewage spousestat fatherstat motherstat type weight14_c weight14_l  y14b005 y14b224 y14b225 y14b220 y14b221 y14b222 y14b223 y14b163 y14b210 y14b211 y14b501 y14b502 y14b504 y14b505 y14b506 y14b507z y14b508z y14b509 y14b519 y14b520 y14b521 y14b522 y14b161 y14b529 y14b530 y14b531 y14b532z y14b533z y14b534 y14b544 y14b545 y14b546 y14b547 y14b554 y14b555 y14b556 y14b557z y14b558z y14b559 y14b569 y14b570 y14b571 y14b572







** 횡단면 가중치
weight**_c

** 종단면 가중치
weight**_l

*****


** 고등학교 학교계열 1차, 9차
y**a316


** 1번째 대학 전공계열 1차, 9차에만

y**a329

* 대학유형
y**a333

* 2번째 대학교
y**a343 / y**a347

* 대학원 전공 y**a358
* 대학원 학위과정 y**a360


** 재학 중 취업자 근로형태 y**b005

/** 임금 (임금근로자의 경우)
임금단위 y**b224
현직장임금 y**b225
정규근로시간 y**b220
초과근로시간 y**b221
정규근로일수 y**b222
초관근로일수 y**b223
y**b163 근로계약기간
퇴직금 y**b210
상여금 y**b211
Y**b501 동시일자리 유무
Y**b502 동시일자리 개수

동시일자리 1 근무시작시기 (년) y**b504
동시일자리 1근무시작시기(월) y**b505
동시일자리1 유형 1 y**b506
동시일자리1 산업코드 대분류 y**b507z
동시일자리1 직업코드 대분류 y**b508z
동시일잘리1 종사장 지위 y**b509
동시일자리1 주당평균근로시간 y**b519
동시일자리1 주당평균근로일수 y**b520
동시일자리1 임금지급단위 y**b521
동시일자리1 임금 y**b522

동시일자리 2 근무시작시기 (년) y**b529
동시일자리 2근무시작시기(월) y**b530
동시일자리2 유형 y**b531
동시일자리2 산업코드 대분류 y**b532z
동시일자리2 직업코드 대분류 y**b533z
동시일자리2 종사장 지위 y**b534
동시일자리2 주당평균근로시간 y**b544
동시일자리2 주당평균근로일수 y**b545
동시일자리2 임금지급단위 y**b546
동시일자리2 임금 y**b547


동시일자리 3 근무시작시기 (년) y**b554
동시일자리 3근무시작시기(월) y**b555
동시일자리3 유형 y**b556
동시일자리3 산업코드 대분류 y**b557z
동시일자리3 직업코드 대분류 y**b558z
동시일자리3 종사장 지위 y**b559
동시일자리3 주당평균근로시간 y**b569
동시일자리3 주당평균근로일수 y**b570
동시일자리3 임금지급단위 y**b571
동시일자리3 임금 y**b572

y14b161
