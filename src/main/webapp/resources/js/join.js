/* [회원가입] 초기화 및 아이콘 로드 */
document.addEventListener("DOMContentLoaded", function() {
    if (typeof lucide !== 'undefined') lucide.createIcons();
});

let currentStep = 1;

/* [회원가입] 품종 '기타' 선택 시 입력창 토글 */
function toggleOtherInput() {
    var select = document.getElementById('breedSelect');
    var container = document.getElementById('otherBreedContainer');
    if (select.value === 'OTHER') {
        container.classList.remove('hidden');
        document.getElementById('otherBreedInput').focus();
    } else {
        container.classList.add('hidden');
    }
}

/* [회원가입] 다음 단계 진행 로직 */
function nextStep() {
    // STEP 1: 계정 정보 검증
    if (currentStep === 1) {
        var id = document.getElementsByName('id')[0].value;
        var pw1 = document.getElementById('pw1').value;
        var pw2 = document.getElementById('pw2').value;
        var nick = document.getElementsByName('nickname')[0].value;

        if (!id || !pw1 || !nick) { alert("정보를 모두 입력해 주세요."); return; }
        if (pw1 !== pw2) { alert("비밀번호가 일치하지 않습니다."); return; }
        if (pw1.length < 6) { alert("비밀번호는 6자리 이상이어야 합니다."); return; }

        // UI 업데이트
        document.getElementById('step1').classList.add('hidden');
        document.getElementById('step2').classList.remove('hidden');
        document.getElementById('step2').classList.add('fade-in-up');
        
        var bar2 = document.getElementById('bar2');
        bar2.classList.remove('bg-gray-200', 'w-2');
        bar2.classList.add('bg-primary', 'w-8');
        
        currentStep = 2;
        window.scrollTo(0, 0);
        if (typeof lucide !== 'undefined') lucide.createIcons();

    // STEP 2: 반려동물 정보 검증
    } else if (currentStep === 2) {
        var name = document.getElementsByName('dogName')[0].value;
        var size = document.querySelector('input[name="dogSize"]:checked');

        if (!name || !size) { alert("우리 아이의 정보를 입력해 주세요."); return; }

        // UI 업데이트
        document.getElementById('step2').classList.add('hidden');
        document.getElementById('step3').classList.remove('hidden');
        document.getElementById('step3').classList.add('fade-in-up');
        
        var bar3 = document.getElementById('bar3');
        bar3.classList.remove('bg-gray-200', 'w-2');
        bar3.classList.add('bg-primary', 'w-8');
        
        document.getElementById('nextBtn').innerText = "가입 완료";
        currentStep = 3;
        window.scrollTo(0, 0);
        if (typeof lucide !== 'undefined') lucide.createIcons();

    // STEP 3: 취향 정보 검증 및 제출
    } else {
        var breedSelect = document.getElementById('breedSelect');
        var otherInput = document.getElementById('otherBreedInput');
        
        if (!breedSelect.value) { alert("품종을 선택해 주세요."); return; }
        
        // '기타' 선택 시 처리
        if (breedSelect.value === 'OTHER') {
            if (!otherInput.value) { alert("품종을 직접 입력해 주세요."); return; }
            
            var finalBreed = document.createElement('input');
            finalBreed.type = 'hidden';
            finalBreed.name = 'dogBreed';
            finalBreed.value = otherInput.value;
            document.getElementById('joinForm').appendChild(finalBreed);
            breedSelect.name = ""; // 중복 방지
        }
        
        document.getElementById('joinForm').submit();
    }
}