// State management
let state = {
    passengers: 1,
    selectedPackage: {
        price: 5000,
        benefit: 50,
        name: 'Car'
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
    updateBenefitsDisplay();
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
        alert('Ngày sinh không thể là ngày tương lai');
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
    document.querySelectorAll('.package-card').forEach(card => {
        card.classList.remove('selected');
    });

    selectedCard.classList.add('selected');

    const price = parseInt(selectedCard.getAttribute('data-price'));
    const benefit = parseInt(selectedCard.getAttribute('data-benefit'));

    state.selectedPackage = {
        price: price,
        benefit: benefit,
        name: selectedCard.querySelector('.package-name').textContent
    };

    updateTotalAmount();
    updateBenefitsDisplay();
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
    const total = state.selectedPackage.price * numberOfPeople * days;
    totalElement.textContent = formatCurrency(total) + ' VNĐ';
}

function updateBenefitsDisplay() {
    const benefitAmounts = document.querySelectorAll('.benefit-amount');

    benefitAmounts.forEach(el => {
        const baseAmount = parseFloat(el.getAttribute('data-base')) || 0;
        const newAmount = baseAmount * state.selectedPackage.benefit;
        el.textContent = formatCurrency(newAmount) + ' VNĐ';
    });
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
        if (confirm('Bạn Có Chắc Chắn Muốn Quay Lại Không? Thông Tin Đã Chọn Sẽ Bị Mất.')) {
            window.history.back();
        }
    }
}

//Modify validate step 4
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
        alert('Vui Lòng Chọn Ngày Bắt Đầu Bảo Hiểm');
        return false;
    }

    if (!state.endDate) {
        alert('Vui Lòng Chọn Ngày Kết Thúc Bảo Hiểm');
        return false;
    }

    if (!validateDates()) {
        return false;
    }

    if (!state.selectedPackage) {
        alert('Vui Lòng Chọn Gói Bảo Hiểm');
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
            alert('Vui Lòng Điền Vào Tất Cả Các Trường Bắt Buộc (*)');
            return false;
        }

        if (!validateBirthDate(birthDate)) {
            return false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert('Địa Chỉ Email Không Hợp Lệ');
            return false;
        }

        const phoneRegex = /^(0|\+84)[0-9]{9}$/;
        if (!phoneRegex.test(phoneNumber.replace(/\s/g, ''))) {
            alert('Số Điện Thoại Không Hợp Lệ');
            return false;
        }
    } else {
        const inputs = document.getElementById('organizationForm').querySelectorAll('.form-input');
        for (let input of inputs) {
            if (!input.value.trim()) {
                alert('Vui Lòng Điền Vào Tất Cả Các Trường Bắt Buộc (*)');
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
        alert('Vui Lòng Thêm Ít Nhất Một Người Được Bảo Hiểm');
        return false;
    }
    return true;
}

//Validate policy
function validateStep4() {
    const agreeTerms = document.getElementById('agreeTerms');
    if (!agreeTerms || !agreeTerms.checked) {
        alert('Vui lòng đồng ý với Chính sách bảo vệ dữ liệu cá nhân của trang để tiếp tục');
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

    if (!fullName || !idNumber || !birthDate || !phoneNumber || !email) {
        alert('Vui lòng điền vào tất cả các trường bắt buộc (*)');
        return;
    }

    if (!validateBirthDate(birthDate)) {
        return;
    }

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
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 40px;">Chưa có người được bảo hiểm. Nhấn nút "Thêm Người Được Bảo Hiểm" để thêm.</p>';
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
        <div class="detail-row"><span class="detail-label">Mã Số Thuế:</span><span class="detail-value">${state.buyerInfo.taxCode}</span></div>
        <div class="detail-row"><span class="detail-label">Đại Diện:</span><span class="detail-value">${state.buyerInfo.representative}</span></div>
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
    const totalPrice = state.selectedPackage.price * state.insuredPersons.length * days;

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
    const urlParams = new URLSearchParams(window.location.search);
    const insuranceId = urlParams.get('insuranceId') || urlParams.get('id');

    if (!insuranceId) {
        alert('Không tìm thấy ID bảo hiểm');
        return;
    }

    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'purchase-insurance';

    addHiddenField(form, 'insuranceId', insuranceId);
    addHiddenField(form, 'type', INSURANCE_TYPE);
    addHiddenField(form, 'benefit-id', BENEFIT_ID);
    addHiddenField(form, 'startDate', state.startDate);
    addHiddenField(form, 'endDate', state.endDate);

    const days = calculateDays();
    const totalPrice = state.selectedPackage.price * state.insuredPersons.length * days;
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
            price: 5000,
            benefit: 50,
            name: 'Car'
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