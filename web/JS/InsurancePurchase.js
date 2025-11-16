// State management
let state = {
    passengers: 1,
    selectedPackage: {
        price: 0,
        benefitId: null,
        productId: null,
        name: '',
        type: '',
        basePrice: 0,
        domesticRate: null,
        internationalRate1_7: null,
        internationalRate8_30: null,
        internationalRate31_90: null,
        internationalRate91_365: null
    },
    startDate: '',
    endDate: '',
    buyerInfo: {},
    insuredPersons: [],
    paymentInfo: {}
};
let currentStep = 1;

// Initialize
document.addEventListener('DOMContentLoaded', function () {
    // Khởi tạo selectedPackage từ gói được chọn ban đầu
    const selectedCard = document.querySelector('.package-card.selected');
    if (selectedCard && !selectedCard.classList.contains('disabled')) {
        const basePrice = parseFloat(selectedCard.getAttribute('data-price')) || 0;
        const benefitId = selectedCard.getAttribute('data-benefit-id');
        const productId = selectedCard.getAttribute('data-product-id');
        const packageName = selectedCard.querySelector('.package-name')?.textContent || '';
        const productName = selectedCard.getAttribute('data-product-name') || '';
        const productType = selectedCard.getAttribute('data-product-type') || '';
        const domesticRate = parseFloat(selectedCard.getAttribute('data-domestic-rate')) || null;
        const intRate1_7 = parseFloat(selectedCard.getAttribute('data-international-rate-1-7')) || null;
        const intRate8_30 = parseFloat(selectedCard.getAttribute('data-international-rate-8-30')) || null;
        const intRate31_90 = parseFloat(selectedCard.getAttribute('data-international-rate-31-90')) || null;
        const intRate91_365 = parseFloat(selectedCard.getAttribute('data-international-rate-91-365')) || null;
        
        state.selectedPackage = {
            price: basePrice,
            basePrice: basePrice,
            benefitId: benefitId,
            productId: productId,
            name: packageName,
            type: productType,
            domesticRate: domesticRate,
            internationalRate1_7: intRate1_7,
            internationalRate8_30: intRate8_30,
            internationalRate31_90: intRate31_90,
            internationalRate91_365: intRate91_365
        };
        
        // Cập nhật tên gói hiển thị từ package được chọn ban đầu
        if (productName) {
            const insuranceTitle = document.querySelector('.purchase-card .card-title');
            if (insuranceTitle) {
                    insuranceTitle.textContent = productName;
            }
        }
        
        // Cập nhật benefits từ package được chọn ban đầu
        updateBenefitsFromPackage(selectedCard);
    }
    
    initPackageSelection();
    initPassengerInput();
    initDateInputs();
    initBottomBar();
    initTabSwitching();
    initBirthDateValidation();
    initPaymentForm();

    // Set default values
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('startDate').value = today;
    document.getElementById('endDate').value = today;
    document.getElementById('startDate').setAttribute('min', today);
    document.getElementById('endDate').setAttribute('min', today);

    state.startDate = today;
    state.endDate = today;

    // Update initial display
    updateTotalAmount();
});

// Initialize payment form
function initPaymentForm() {
    const cardInput = document.getElementById('cardNumber');
    if (cardInput) {
        cardInput.addEventListener('input', formatCardNumber);
    }

    const expiryInput = document.getElementById('expiryDate');
    if (expiryInput) {
        expiryInput.addEventListener('input', formatExpiryDate);
    }

    const cvvInput = document.getElementById('cvv');
    if (cvvInput) {
        cvvInput.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, '').slice(0, 3);
        });
    }
}

function formatCardNumber(e) {
    let value = e.target.value.replace(/\s/g, '').replace(/\D/g, '');
    let formattedValue = value.replace(/(.{4})/g, '$1 ').trim();
    e.target.value = formattedValue.slice(0, 19);
}

function formatExpiryDate(e) {
    let value = e.target.value.replace(/\D/g, '');
    if (value.length >= 2) {
        value = value.slice(0, 2) + '/' + value.slice(2, 4);
    }
    e.target.value = value.slice(0, 5);
}

// Initialize birth date validation
function initBirthDateValidation() {
    const today = new Date().toISOString().split('T')[0];

    const buyerBirthDate = document.getElementById('birthDate');
    if (buyerBirthDate) {
        buyerBirthDate.setAttribute('max', today);
    }

    const personBirthDate = document.getElementById('personBirthDate');
    if (personBirthDate) {
        personBirthDate.setAttribute('max', today);
    }
}

function validateBirthDate(birthDate) {
    if (!birthDate)
        return false;

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const selectedDate = new Date(birthDate);
    selectedDate.setHours(0, 0, 0, 0);

    if (selectedDate > today) {
        alert('Ngày sinh không thể ở tương lai');
        return false;
    }

    return true;
}

// Package Selection
function initPackageSelection() {
    const packageCards = document.querySelectorAll('.package-card');

    packageCards.forEach(card => {
        card.addEventListener('click', function () {
            selectPackage(this);
        });
    });
}

function selectPackage(selectedCard) {
    // Không cho phép chọn gói disabled
    if (selectedCard.classList.contains('disabled')) {
        return;
    }
    
    document.querySelectorAll('.package-card').forEach(card => {
        card.classList.remove('selected');
    });

    selectedCard.classList.add('selected');

    const basePrice = parseFloat(selectedCard.getAttribute('data-price')) || 0;
    const benefitId = selectedCard.getAttribute('data-benefit-id');
    const productId = selectedCard.getAttribute('data-product-id');
    const productName = selectedCard.getAttribute('data-product-name') || '';
    const productType = selectedCard.getAttribute('data-product-type') || '';
    const domesticRate = parseFloat(selectedCard.getAttribute('data-domestic-rate')) || null;
    const intRate1_7 = parseFloat(selectedCard.getAttribute('data-international-rate-1-7')) || null;
    const intRate8_30 = parseFloat(selectedCard.getAttribute('data-international-rate-8-30')) || null;
    const intRate31_90 = parseFloat(selectedCard.getAttribute('data-international-rate-31-90')) || null;
    const intRate91_365 = parseFloat(selectedCard.getAttribute('data-international-rate-91-365')) || null;

    state.selectedPackage = {
        price: basePrice,
        basePrice: basePrice,
        benefitId: benefitId,
        productId: productId,
        name: selectedCard.querySelector('.package-name').textContent,
        type: productType,
        domesticRate: domesticRate,
        internationalRate1_7: intRate1_7,
        internationalRate8_30: intRate8_30,
        internationalRate31_90: intRate31_90,
        internationalRate91_365: intRate91_365
    };

    // Cập nhật tên gói hiển thị
    const insuranceTitle = document.querySelector('.purchase-card .card-title');
    if (insuranceTitle && productName) {
            insuranceTitle.textContent = productName;
    }

    // Cập nhật quyền lợi bảo hiểm
    updateBenefitsFromPackage(selectedCard);

    updateTotalAmount();
}

function updateBenefitsFromPackage(selectedCard) {
    // Lấy các giá trị benefit từ data attributes
    const deathOrPermanentDisability = parseFloat(selectedCard.getAttribute('data-death-or-permanent-disability')) || 0;
    const deathDueToIllness = parseFloat(selectedCard.getAttribute('data-death-due-to-illness')) || 0;
    const thirdPartyLiability = parseFloat(selectedCard.getAttribute('data-third-party-liability')) || 0;
    const lostBankCard = parseFloat(selectedCard.getAttribute('data-lost-bank-card')) || 0;
    const kidnapAndHostage = parseFloat(selectedCard.getAttribute('data-kidnap-and-hostage')) || 0;
    const lostOrDamagedGolfEquipment = parseFloat(selectedCard.getAttribute('data-lost-or-damaged-golf-equipment')) || 0;

    // Cập nhật từng benefit amount
    const benefitAmounts = document.querySelectorAll('.benefit-amount');
    if (benefitAmounts.length >= 6) {
        // Benefit 1: Tử vong, thương tật vĩnh viễn, thương tật tạm thời
        if (benefitAmounts[0]) {
            benefitAmounts[0].setAttribute('data-base', deathOrPermanentDisability);
            benefitAmounts[0].textContent = formatCurrency(deathOrPermanentDisability) + ' VNĐ';
        }
        // Benefit 2: Tử vong do bệnh tật
        if (benefitAmounts[1]) {
            benefitAmounts[1].setAttribute('data-base', deathDueToIllness);
            benefitAmounts[1].textContent = formatCurrency(deathDueToIllness) + ' VNĐ';
        }
        // Benefit 3: Trách nhiệm cá nhân đối với bên thứ ba
        if (benefitAmounts[2]) {
            benefitAmounts[2].setAttribute('data-base', thirdPartyLiability);
            benefitAmounts[2].textContent = formatCurrency(thirdPartyLiability) + ' VNĐ';
        }
        // Benefit 4: Mất thẻ ngân hàng
        if (benefitAmounts[3]) {
            benefitAmounts[3].setAttribute('data-base', lostBankCard);
            benefitAmounts[3].textContent = formatCurrency(lostBankCard) + ' VNĐ';
        }
        // Benefit 5: Bắt cóc và con tin
        if (benefitAmounts[4]) {
            benefitAmounts[4].setAttribute('data-base', kidnapAndHostage);
            benefitAmounts[4].textContent = formatCurrency(kidnapAndHostage) + ' VNĐ';
        }
        // Benefit 6: Mất hoặc hư hỏng dụng cụ golf
        if (benefitAmounts[5]) {
            benefitAmounts[5].setAttribute('data-base', lostOrDamagedGolfEquipment);
            benefitAmounts[5].textContent = formatCurrency(lostOrDamagedGolfEquipment) + ' VNĐ';
        }
    }
}

// Passenger Input
function initPassengerInput() {
    const passengerInput = document.getElementById('passengerInput');

    passengerInput.addEventListener('input', function () {
        let value = parseInt(this.value);
        if (value < 1) {
            value = 1;
            this.value = 1;
        }
        state.passengers = value;
        updateTotalAmount();
    });
}

// Date Inputs
function initDateInputs() {
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');

    startDateInput.addEventListener('change', function () {
        state.startDate = this.value;
        endDateInput.setAttribute('min', this.value);
        if (validateDates()) {
            updateTotalAmount();
        }
    });

    endDateInput.addEventListener('change', function () {
        state.endDate = this.value;
        if (validateDates()) {
            updateTotalAmount();
        }
    });
}

function validateDates() {
    if (state.startDate && state.endDate) {
        const start = new Date(state.startDate);
        const end = new Date(state.endDate);
        const diffDays = Math.ceil((end - start) / (1000 * 60 * 60 * 24));

        if (diffDays > 180) {
            alert('Thời hạn bảo hiểm không được vượt quá 180 ngày');
            return false;
        } else if (diffDays < 0) {
            alert('Ngày kết thúc phải sau ngày bắt đầu');
            return false;
        }
    }
    return true;
}

function calculateDays() {
    if (!state.startDate || !state.endDate)
        return 1;

    const start = new Date(state.startDate);
    const end = new Date(state.endDate);
    const diffTime = end - start;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;

    return diffDays > 0 ? diffDays : 1;
}

function updateTotalAmount() {
    const totalElement = document.getElementById('totalAmount');
    const days = calculateDays();
    const numberOfPeople = state.insuredPersons.length > 0 ? state.insuredPersons.length : 1;
    
    let pricePerPerson = 0;
    
    // Tính giá theo loại sản phẩm và số ngày
    if (state.selectedPackage.type === 'international') {
        // Sản phẩm quốc tế - chọn giá theo ngày từ bảng phí
        // Công thức: Phí = Biểu phí theo ngày x số ngày x số người
        let perDayPrice = null;
        if (days <= 7) {
            perDayPrice = state.selectedPackage.internationalRate1_7;
        } else if (days <= 30) {
            perDayPrice = state.selectedPackage.internationalRate8_30;
        } else if (days <= 90) {
            perDayPrice = state.selectedPackage.internationalRate31_90;
        } else {
            perDayPrice = state.selectedPackage.internationalRate91_365;
        }
        
        if (perDayPrice != null && perDayPrice > 0) {
            // Phí cho 1 người = Biểu phí theo ngày x số ngày
            pricePerPerson = perDayPrice * days;
        } else {
            // Fallback - dùng base price nếu không có giá theo ngày
            pricePerPerson = state.selectedPackage.basePrice * days;
        }
    } else if (state.selectedPackage.type === 'domestic') {
        // Sản phẩm nội địa - basePrice đã là giá cuối cùng (max benefit × rate)
        // Công thức: Phí = basePrice × số ngày
        // Không nhân thêm rate vì basePrice đã tính sẵn
        pricePerPerson = state.selectedPackage.basePrice * days;
    } else {
        // Fallback - dùng base price
        pricePerPerson = state.selectedPackage.basePrice * days;
    }
    
    // Cập nhật price trong state để hiển thị (đã bao gồm số ngày)
    state.selectedPackage.price = pricePerPerson;
    
    // Tổng phí = Phí cho 1 người x số người
    const total = pricePerPerson * numberOfPeople;
    totalElement.textContent = formatCurrency(total) + ' VNĐ';
}

function updateBenefitsDisplay() {
    // Benefits đã được hiển thị đúng từ database, không cần nhân thêm
    // Hàm này giữ lại để tương thích với code hiện tại nhưng không làm gì
    // Nếu cần update benefits khi chọn gói mới, cần reload page hoặc load qua AJAX
}

function formatCurrency(amount) {
//    return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    if (Number.isInteger(amount)) {
        return amount.toLocaleString('vi-VN', {minimumFractionDigits: 0, maximumFractionDigits: 0});
    } else {
        return amount.toLocaleString('vi-VN', {minimumFractionDigits: 2, maximumFractionDigits: 2});
    }
}

// Tab switching (Individual/Organization)
function initTabSwitching() {
    const tabBtns = document.querySelectorAll('.tab-btn');
    const individualForm = document.getElementById('individualForm');
    const organizationForm = document.getElementById('organizationForm');

    tabBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            const tab = this.dataset.tab;

            tabBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            if (tab === 'individual') {
                individualForm.style.display = 'block';
                organizationForm.style.display = 'none';
            } else {
                individualForm.style.display = 'none';
                organizationForm.style.display = 'block';
            }
        });
    });
}

// Bottom Bar Actions
function initBottomBar() {
    const backBtn = document.getElementById('backBtn');
    const continueBtn = document.getElementById('continueBtn');

    backBtn.addEventListener('click', handleBack);
    continueBtn.addEventListener('click', handleContinue);
}

function handleBack() {
    if (currentStep === 2) {
        moveToStep(1);
    } else if (currentStep === 3) {
        moveToStep(2);
    } else if (currentStep === 4) {
        moveToStep(3);
    } else if (currentStep === 5) {
        moveToStep(4);
    } else if (currentStep === 1) {
        if (confirm('Bạn có chắc chắn muốn quay lại không? Thông tin đã chọn sẽ bị mất.')) {
            window.history.back();
        }
    }
}

function handleContinue() {
    if (currentStep === 1 && validateStep1()) {
        moveToStep(2);
    } else if (currentStep === 2 && validateStep2()) {
        saveBuyerInfo();
        moveToStep(3);
    } else if (currentStep === 3 && validateStep3()) {
        renderConfirmation();
        moveToStep(4);
    } else if (currentStep === 4 && validateStep4()) {
        renderPaymentSummary();
        moveToStep(5);
    } else if (currentStep === 5 && validateStep5()) {
        savePaymentInfo();
        submitForm();
    }
}

function moveToStep(step) {
    for (let i = 1; i <= 5; i++) {
        const content = document.getElementById(`step${i}Content`);
        if (content)
            content.style.display = 'none';
    }

    const targetContent = document.getElementById(`step${step}Content`);
    if (targetContent) {
        targetContent.style.display = step === 1 ? 'grid' : 'block';
    }

    updateProgressIndicator(step);

    currentStep = step;
    window.scrollTo({top: 0, behavior: 'smooth'});
}

function updateProgressIndicator(step) {
    for (let i = 1; i <= 5; i++) {
        const indicator = document.getElementById(`step${i}`);
        if (!indicator)
            continue;

        const circle = indicator.querySelector('.progress-circle');

        if (i < step) {
            indicator.classList.remove('active');
            indicator.classList.add('completed');
            circle.textContent = '✓';
        } else if (i === step) {
            indicator.classList.add('active');
            indicator.classList.remove('completed');
            circle.textContent = '✓';
        } else {
            indicator.classList.remove('active', 'completed');
            circle.textContent = i;
        }
    }
}

function validateStep1() {
    if (!state.startDate) {
        alert('Vui lòng chọn ngày bắt đầu bảo hiểm');
        return false;
    }

    if (!state.endDate) {
        alert('Vui lòng chọn ngày kết thúc bảo hiểm');
        return false;
    }

    if (!validateDates()) {
        return false;
    }

    if (!state.selectedPackage) {
        alert('Vui lòng chọn gói bảo hiểm');
        return false;
    }

    return true;
}

function validateStep2() {
    const activeTab = document.querySelector('.tab-btn.active').dataset.tab;

    if (activeTab === 'individual') {
        const idNumber = document.getElementById('idNumber').value.trim();
        const fullName = document.getElementById('fullName').value.trim();
        const birthDate = document.getElementById('birthDate').value;
        const phoneNumber = document.getElementById('phoneNumber').value.trim();
        const email = document.getElementById('email').value.trim();
        const address = document.getElementById('address').value.trim();

        if (!idNumber || !fullName || !birthDate || !phoneNumber || !email || !address) {
            alert('Vui lòng điền vào tất cả các trường bắt buộc (*)');
            return false;
        }

        if (!validateBirthDate(birthDate)) {
            return false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert('Địa chỉ email không hợp lệ');
            return false;
        }

        const phoneRegex = /^(0|\+84)[0-9]{9}$/;
        if (!phoneRegex.test(phoneNumber.replace(/\s/g, ''))) {
            alert('Số điện thoại không hợp lệ');
            return false;
        }
    } else {
        const inputs = document.getElementById('organizationForm').querySelectorAll('.form-input');
        for (let input of inputs) {
            if (!input.value.trim()) {
                alert('Vui lòng điền vào tất cả các trường bắt buộc (*)');
                return false;
            }
        }
    }

    return true;
}

function saveBuyerInfo() {
    const activeTab = document.querySelector('.tab-btn.active').dataset.tab;

    if (activeTab === 'individual') {
        const gender = document.querySelector('input[name="gender"]').value;
        state.buyerInfo = {
            type: 'individual',
            idNumber: document.getElementById('idNumber').value.trim(),
            fullName: document.getElementById('fullName').value.trim(),
            gender: gender === 'male' ? 'Male' : 'Female',
            birthDate: document.getElementById('birthDate').value,
            phoneNumber: document.getElementById('phoneNumber').value.trim(),
            email: document.getElementById('email').value.trim(),
            address: document.getElementById('address').value.trim()
        };
    } else {
        const orgInputs = document.getElementById('organizationForm').querySelectorAll('.form-input');
        state.buyerInfo = {
            type: 'organization',
            taxCode: orgInputs[0].value.trim(),
            orgName: orgInputs[1].value.trim(),
            representative: orgInputs[2].value.trim(),
            phoneNumber: orgInputs[3].value.trim(),
            email: orgInputs[4].value.trim(),
            address: orgInputs[5].value.trim()
        };
    }
}

function validateStep3() {
    if (state.insuredPersons.length === 0) {
        alert('Vui lòng thêm ít nhất một người được bảo hiểm');
        return false;
    }
    return true;
}

//Validate policy
function validateStep4() {
    const agreeTerms = document.getElementById('agreeTerms');
    if (!agreeTerms || !agreeTerms.checked) {
        alert('Vui lòng đồng ý với Chính sách bảo vệ dữ liệu cá nhân của Trang để tiếp tục');
        return false;
    }
    return true;
}

function validateStep5() {
    const cardholderName = document.getElementById('cardholderName').value.trim();
    const cardNumber = document.getElementById('cardNumber').value.replace(/\s/g, '');
    const expiryDate = document.getElementById('expiryDate').value;
    const cvv = document.getElementById('cvv').value;

    if (!cardholderName) {
        alert('Vui lòng nhập tên chủ thẻ');
        return false;
    }

    if (cardNumber.length !== 16 || isNaN(cardNumber)) {
        alert('Vui lòng nhập số thẻ hợp lệ gồm 16 chữ số');
        return false;
    }

    if (!expiryDate || expiryDate.length !== 5) {
        alert('Vui lòng nhập ngày hết hạn theo định dạng MM/YY');
        return false;
    }

    const [month, year] = expiryDate.split('/');
    const expiry = new Date(2000 + parseInt(year), parseInt(month) - 1);
    const today = new Date();
    if (expiry <= today) {
        alert('Thẻ đã hết hạn');
        return false;
    }

    if (cvv.length !== 3 || isNaN(cvv)) {
        alert('Vui lòng nhập mã CVV 3 chữ số hợp lệ');
        return false;
    }

    return true;
}

function savePaymentInfo() {
    state.paymentInfo = {
        cardholderName: document.getElementById('cardholderName').value.trim(),
        cardNumber: document.getElementById('cardNumber').value.replace(/\s/g, ''),
        expiryDate: document.getElementById('expiryDate').value,
        cvv: document.getElementById('cvv').value
    };
}

// Step 3: Add Insured Person
function openAddPersonModal() {
    document.getElementById('addPersonModal').style.display = 'flex';
}

function closeAddPersonModal() {
    document.getElementById('addPersonModal').style.display = 'none';
    document.getElementById('personForm').reset();
}

function saveInsuredPerson() {
    const fullName = document.getElementById('personFullName').value.trim();
    const idNumber = document.getElementById('personIdNumber').value.trim();
    const gender = document.querySelector('input[name="personGender"]:checked').value;
    const birthDate = document.getElementById('personBirthDate').value;
    const phoneNumber = document.getElementById('personPhoneNumber').value.trim();
    const email = document.getElementById('personEmail').value.trim();
    
    // Biểu thức regex
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const numberRegex = /^[0-9]+$/;
    const phoneRegex = /^[0-9]{10,11}$/; // Số điện thoại 10-11 chữ số
    
    // Xóa tất cả lỗi cũ
    clearAllErrors();
    
    let hasError = false;
    
    // Kiểm tra từng trường và hiển thị lỗi cụ thể
    if (!fullName) {
        showFieldError('personFullName', 'Vui lòng nhập họ và tên');
        hasError = true;
    }
    
    if (!idNumber) {
        showFieldError('personIdNumber', 'Vui lòng nhập số CCCD');
        hasError = true;
    } else if (!numberRegex.test(idNumber)) {
        showFieldError('personIdNumber', 'Số CCCD phải là số!');
        hasError = true;
    } else if (idNumber.length !== 9 && idNumber.length !== 12) {
        showFieldError('personIdNumber', 'Số CCCD phải có 9 hoặc 12 chữ số');
        hasError = true;
    }
    
    if (!birthDate) {
        showFieldError('personBirthDate', 'Vui lòng chọn ngày sinh');
        hasError = true;
    } else if (typeof validateBirthDate === 'function' && !validateBirthDate(birthDate)) {
        showFieldError('personBirthDate', 'Ngày sinh không hợp lệ');
        hasError = true;
    }
    
    if (!phoneNumber) {
        showFieldError('personPhoneNumber', 'Vui lòng nhập số điện thoại');
        hasError = true;
    } else if (!phoneRegex.test(phoneNumber)) {
        showFieldError('personPhoneNumber', 'Số điện thoại phải là 10-11 chữ số!');
        hasError = true;
    }
    
    if (!email) {
        showFieldError('personEmail', 'Vui lòng nhập email');
        hasError = true;
    } else if (!emailRegex.test(email)) {
        showFieldError('personEmail', 'Email không đúng định dạng!');
        hasError = true;
    }
    
    // Nếu có lỗi, dừng lại
    if (hasError) {
        return;
    }
    
    // Nếu hợp lệ => thêm vào danh sách
    const person = {
        id: Date.now(),
        fullName,
        idNumber,
        gender: gender === 'male' ? 'Male' : 'Female',
        birthDate,
        phoneNumber,
        email
    };
    
    state.insuredPersons.push(person);
    renderInsuredPersonsList();
    closeAddPersonModal();
    updateTotalAmount();
}

// Hàm hiển thị lỗi cho từng field
function showFieldError(inputId, message) {
    const input = document.getElementById(inputId);
    const formGroup = input.closest('.form-group');
    
    // Thêm class error vào input
    input.classList.add('error');
    
    // Tạo hoặc cập nhật thông báo lỗi
    let errorMsg = formGroup.querySelector('.error-message');
    if (!errorMsg) {
        errorMsg = document.createElement('div');
        errorMsg.className = 'error-message';
        formGroup.appendChild(errorMsg);
    }
    errorMsg.textContent = message;
    
    // Focus vào field đầu tiên có lỗi
    if (!document.querySelector('.form-input.error:focus')) {
        input.focus();
    }
}

// Hàm xóa tất cả lỗi
function clearAllErrors() {
    document.querySelectorAll('.form-input').forEach(input => {
        input.classList.remove('error');
    });
    document.querySelectorAll('.error-message').forEach(msg => {
        msg.remove();
    });
}

// Xóa lỗi khi người dùng bắt đầu nhập
document.addEventListener('DOMContentLoaded', function() {
    const inputs = ['personFullName', 'personIdNumber', 'personBirthDate', 'personPhoneNumber', 'personEmail'];
    
    inputs.forEach(inputId => {
        const input = document.getElementById(inputId);
        if (input) {
            input.addEventListener('input', function() {
                this.classList.remove('error');
                const errorMsg = this.closest('.form-group').querySelector('.error-message');
                if (errorMsg) {
                    errorMsg.remove();
                }
            });
        }
    });
});

// CSS để hiển thị lỗi đẹp hơn
if (!document.getElementById('form-validation-styles')) {
    const style = document.createElement('style');
    style.id = 'form-validation-styles';
    style.textContent = `
        .form-input.error {
            border: 2px solid #e74c3c !important;
            background-color: #fff5f5;
        }
        
        .error-message {
            color: #e74c3c;
            font-size: 13px;
            margin-top: 5px;
            display: flex;
            align-items: center;
            animation: slideDown 0.3s ease;
        }
        
        .error-message::before {
            content: "";
            margin-right: 5px;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .form-input.error:focus {
            outline: none;
            border-color: #e74c3c;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }
    `;
    document.head.appendChild(style);
}

function removeInsuredPerson(id) {
    if (confirm('Bạn có chắc chắn muốn xóa người này không?')) {
        state.insuredPersons = state.insuredPersons.filter(p => p.id !== id);
        renderInsuredPersonsList();
        updateTotalAmount();
    }
}

function renderInsuredPersonsList() {
    const container = document.getElementById('insuredPersonsList');

    if (state.insuredPersons.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 40px;">Chưa có người được bảo hiểm. Nhấp vào nút "Thêm người được bảo hiểm" để thêm.</p>';
        return;
    }

    container.innerHTML = state.insuredPersons.map((person, index) => `
        <div class="insured-person-card">
            <div class="person-header">
                <h4>${index + 1}. ${person.fullName}</h4>
                <button class="remove-person-btn" onclick="removeInsuredPerson(${person.id})">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <path d="M15 5L5 15M5 5l10 10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                    </svg>
                </button>
            </div>
            <div class="person-details">
                <div class="detail-row">
                    <span class="detail-label">Giới Tính:</span>
                    <span class="detail-value">${person.gender}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Số CCCD:</span>
                    <span class="detail-value">${person.idNumber}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Ngày Sinh:</span>
                    <span class="detail-value">${person.birthDate}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Số Điện Thoại:</span>
                    <span class="detail-value">${person.phoneNumber}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email:</span>
                    <span class="detail-value">${person.email}</span>
                </div>
            </div>
        </div>
    `).join('');
}

// Step 4: Render confirmation
function renderConfirmation() {
    const container = document.getElementById('confirmationContent');

    const buyerInfoHtml = state.buyerInfo.type === 'individual' ? `
        <div class="detail-row"><span class="detail-label">Họ Và Tên:</span><span class="detail-value">${state.buyerInfo.fullName}</span></div>
        <div class="detail-row"><span class="detail-label">Giới Tính:</span><span class="detail-value">${state.buyerInfo.gender}</span></div>
        <div class="detail-row"><span class="detail-label">Số CCCD:</span><span class="detail-value">${state.buyerInfo.idNumber}</span></div>
        <div class="detail-row"><span class="detail-label">Ngày Sinh:</span><span class="detail-value">${state.buyerInfo.birthDate}</span></div>
        <div class="detail-row"><span class="detail-label">Số Điện Thoại:</span><span class="detail-value">${state.buyerInfo.phoneNumber}</span></div>
        <div class="detail-row"><span class="detail-label">Email:</span><span class="detail-value">${state.buyerInfo.email}</span></div>
        <div class="detail-row"><span class="detail-label">Địa Chỉ:</span><span class="detail-value">${state.buyerInfo.address}</span></div>
    ` : `
        <div class="detail-row"><span class="detail-label">Tên Tổ Chức:</span><span class="detail-value">${state.buyerInfo.orgName}</span></div>
        <div class="detail-row"><span class="detail-label">Mã số thuế:</span><span class="detail-value">${state.buyerInfo.taxCode}</span></div>
        <div class="detail-row"><span class="detail-label">Người Đại Diện:</span><span class="detail-value">${state.buyerInfo.representative}</span></div>
        <div class="detail-row"><span class="detail-label">Số Điện Thoại:</span><span class="detail-value">${state.buyerInfo.phoneNumber}</span></div>
        <div class="detail-row"><span class="detail-label">Email:</span><span class="detail-value">${state.buyerInfo.email}</span></div>
        <div class="detail-row"><span class="detail-label">Địa Chỉ:</span><span class="detail-value">${state.buyerInfo.address}</span></div>
    `;

    container.innerHTML = `
        <div class="confirmation-section">
            <h3 class="section-title">Thông Tin Gói Bảo Hiểm</h3>
            <div class="detail-row"><span class="detail-label">Tên Gói:</span><span class="detail-value">${state.selectedPackage.name}</span></div>
            <div class="detail-row"><span class="detail-label">Ngày Bắt Đầu:</span><span class="detail-value">${state.startDate}</span></div>
            <div class="detail-row"><span class="detail-label">Ngày Kết Thúc:</span><span class="detail-value">${state.endDate}</span></div>
            <div class="detail-row"><span class="detail-label">Phí/Người:</span><span class="detail-value">${formatCurrency(state.selectedPackage.price)} VNĐ</span></div>
        </div>
        
        <div class="confirmation-section">
            <h3 class="section-title">Thông Tin Người Mua Bảo Hiểm</h3>
            ${buyerInfoHtml}
        </div>
        
        <div class="confirmation-section">
            <h3 class="section-title">Danh Sách Người Được Bảo Hiểm (${state.insuredPersons.length})</h3>
            ${state.insuredPersons.map((person, index) => `
                <div class="insured-summary">
                    <strong>${index + 1}. ${person.fullName}</strong> - ${person.gender} - ${person.idNumber}
                </div>
            `).join('')}
        </div>
    `;
}

// Step 5: Render payment summary
function renderPaymentSummary() {
    const container = document.getElementById('paymentSummaryContent');
    const days = calculateDays();
    // state.selectedPackage.price đã bao gồm số ngày rồi, chỉ cần nhân với số người
    const totalPrice = state.selectedPackage.price * state.insuredPersons.length;

    container.innerHTML = `
        <div class="payment-summary-section">
            <h3 class="section-title">Tóm Tắt Đơn Hàng</h3>
            <div class="detail-row">
                <span class="detail-label">Gói:</span>
                <span class="detail-value">${state.selectedPackage.name}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Số Lượng Khách Du Lịch:</span>
                <span class="detail-value">${state.insuredPersons.length}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Số Ngày:</span>
                <span class="detail-value">${days}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Giá Mỗi Người:</span>
                <span class="detail-value">${formatCurrency(state.selectedPackage.price)} VNĐ</span>
            </div>
            <div class="detail-row" style="border-top: 2px solid #e74c3c; padding-top: 12px; margin-top: 12px;">
                <span class="detail-label" style="font-weight: 600; font-size: 15px;">Tổng Số Tiền:</span>
                <span class="detail-value" style="font-weight: 600; font-size: 16px; color: #e74c3c;">${formatCurrency(totalPrice)} VNĐ</span>
            </div>
        </div>
    `;
}

function submitForm() {
    // Sử dụng productId từ selectedPackage thay vì lấy từ URL
    const productId = state.selectedPackage.productId;
    
    if (!productId) {
        alert('Vui lòng chọn gói bảo hiểm');
        return;
    }

    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'purchase-insurance';

    addHiddenField(form, 'insuranceId', productId);
    addHiddenField(form, 'type', INSURANCE_TYPE);
    addHiddenField(form, 'benefit-id', state.selectedPackage.benefitId || BENEFIT_ID);
    addHiddenField(form, 'startDate', state.startDate);
    addHiddenField(form, 'endDate', state.endDate);

    const days = calculateDays();
    // state.selectedPackage.price đã bao gồm số ngày rồi, chỉ cần nhân với số người
    const totalPrice = state.selectedPackage.price * state.insuredPersons.length;
    addHiddenField(form, 'totalPrice', totalPrice);

    if (state.buyerInfo.type === 'individual') {
        addHiddenField(form, 'buyerType', 'individual');
        addHiddenField(form, 'buyerIdNumber', state.buyerInfo.idNumber);
        addHiddenField(form, 'buyerFullName', state.buyerInfo.fullName);
        addHiddenField(form, 'buyerGender', state.buyerInfo.gender);
        addHiddenField(form, 'buyerBirthDate', state.buyerInfo.birthDate);
        addHiddenField(form, 'buyerPhoneNumber', state.buyerInfo.phoneNumber);
        addHiddenField(form, 'buyerEmail', state.buyerInfo.email);
        addHiddenField(form, 'buyerAddress', state.buyerInfo.address);
    } else {
        addHiddenField(form, 'buyerType', 'organization');
        addHiddenField(form, 'buyerTaxCode', state.buyerInfo.taxCode);
        addHiddenField(form, 'buyerOrgName', state.buyerInfo.orgName);
        addHiddenField(form, 'buyerRepresentative', state.buyerInfo.representative);
        addHiddenField(form, 'buyerPhoneNumber', state.buyerInfo.phoneNumber);
        addHiddenField(form, 'buyerEmail', state.buyerInfo.email);
        addHiddenField(form, 'buyerAddress', state.buyerInfo.address);
    }

    addHiddenField(form, 'travelersCount', state.insuredPersons.length);

    state.insuredPersons.forEach((person, index) => {
        addHiddenField(form, `traveler[${index}].fullName`, person.fullName);
        addHiddenField(form, `traveler[${index}].idNumber`, person.idNumber);
        addHiddenField(form, `traveler[${index}].gender`, person.gender);
        addHiddenField(form, `traveler[${index}].birthDate`, person.birthDate);
        addHiddenField(form, `traveler[${index}].phoneNumber`, person.phoneNumber);
        addHiddenField(form, `traveler[${index}].email`, person.email);
    });

    // Add payment information
    addHiddenField(form, 'paymentMethod', 'bank_card');
    addHiddenField(form, 'cardholderName', state.paymentInfo.cardholderName);
    addHiddenField(form, 'cardNumber', state.paymentInfo.cardNumber);
    addHiddenField(form, 'expiryDate', state.paymentInfo.expiryDate);

    document.body.appendChild(form);
    form.submit();
}

function addHiddenField(form, name, value) {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = name;
    input.value = value;
    form.appendChild(input);
}

window.addEventListener('pageshow', function (event) {
    if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
        resetForm();
    }
});

function resetForm() {
    state = {
        passengers: 1,
        selectedPackage: {
            price: 0,
            benefitId: null,
            productId: null,
            name: ''
        },
        startDate: '',
        endDate: '',
        buyerInfo: {},
        insuredPersons: [],
        paymentInfo: {}
    };

    currentStep = 1;

    document.querySelectorAll('input[type="text"], input[type="email"], input[type="tel"], input[type="date"]').forEach(input => {
        input.value = '';
    });

    const today = new Date().toISOString().split('T')[0];
    document.getElementById('startDate').value = today;
    document.getElementById('endDate').value = today;
    state.startDate = today;
    state.endDate = today;

    renderInsuredPersonsList();
    moveToStep(1);
    updateTotalAmount();
    updateBenefitsDisplay();
}