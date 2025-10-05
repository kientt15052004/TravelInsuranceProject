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
    insuredPersons: []
};

let currentStep = 1;

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    initPackageSelection();
    initPassengerInput();
    initDateInputs();
    initBottomBar();
    initTabSwitching();
    
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

// Package Selection
function initPackageSelection() {
    const packageCards = document.querySelectorAll('.package-card');
    
    packageCards.forEach(card => {
        card.addEventListener('click', function() {
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
    
    passengerInput.addEventListener('input', function() {
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
    
    startDateInput.addEventListener('change', function() {
        state.startDate = this.value;
        endDateInput.setAttribute('min', this.value);
        validateDates();
    });
    
    endDateInput.addEventListener('change', function() {
        state.endDate = this.value;
        validateDates();
    });
}

function validateDates() {
    if (state.startDate && state.endDate) {
        const start = new Date(state.startDate);
        const end = new Date(state.endDate);
        const diffDays = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
        
        if (diffDays > 180) {
            alert('The insurance period shall not exceed 180 days.');
            return false;
        } else if (diffDays < 0) {
            alert('The end date must be after the start date.');
            return false;
        }
    }
    return true;
}

// Update total amount display
function updateTotalAmount() {
    const totalElement = document.getElementById('totalAmount');
    const total = state.selectedPackage.price * state.insuredPersons.length;
    totalElement.textContent = formatCurrency(total) + ' VNĐ';
}

// Update benefits display
function updateBenefitsDisplay() {
    const benefitAmounts = document.querySelectorAll('.benefit-amount');
    
    benefitAmounts.forEach(el => {
        const baseAmount = parseFloat(el.getAttribute('data-base')) || 0;
        const newAmount = baseAmount * state.selectedPackage.benefit;
        el.textContent = formatCurrency(newAmount) + ' VNĐ';
    });
}

// Format currency
function formatCurrency(amount) {
    return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// Tab switching (Individual/Organization)
function initTabSwitching() {
    const tabBtns = document.querySelectorAll('.tab-btn');
    const individualForm = document.getElementById('individualForm');
    const organizationForm = document.getElementById('organizationForm');
    
    tabBtns.forEach(btn => {
        btn.addEventListener('click', function() {
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
    } else if (currentStep === 1) {
        if (confirm('Are you sure you want to go back? The selected information will be lost.')) {
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
    } else if (currentStep === 4) {
        submitForm();
    }
}

function moveToStep(step) {
    // Hide all steps
    for (let i = 1; i <= 4; i++) {
        const content = document.getElementById(`step${i}Content`);
        if (content) content.style.display = 'none';
    }
    
    // Show target step
    const targetContent = document.getElementById(`step${step}Content`);
    if (targetContent) {
        targetContent.style.display = step === 1 ? 'grid' : 'block';
    }
    
    // Update progress indicators
    updateProgressIndicator(step);
    
    currentStep = step;
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function updateProgressIndicator(step) {
    for (let i = 1; i <= 4; i++) {
        const indicator = document.getElementById(`step${i}`);
        if (!indicator) continue;
        
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
        alert('Please select insurance start date');
        return false;
    }
    
    if (!state.endDate) {
        alert('Please select insurance end date');
        return false;
    }
    
    if (!validateDates()) {
        return false;
    }
    
    if (!state.selectedPackage) {
        alert('Please select insurance package');
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
            alert('Please fill in all required information (*)');
            return false;
        }
        
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert('Invalid email');
            return false;
        }
        
        const phoneRegex = /^(0|\+84)[0-9]{9}$/;
        if (!phoneRegex.test(phoneNumber.replace(/\s/g, ''))) {
            alert('Invalid phone number');
            return false;
        }
    } else {
        const inputs = document.getElementById('organizationForm').querySelectorAll('.form-input');
        for (let input of inputs) {
            if (!input.value.trim()) {
                alert('Please fill in all required information (*)');
                return false;
            }
        }
    }
    
    return true;
}

function saveBuyerInfo() {
    const activeTab = document.querySelector('.tab-btn.active').dataset.tab;
    
    if (activeTab === 'individual') {
        const gender = document.querySelector('input[name="gender"]:checked').value;
        state.buyerInfo = {
            type: 'individual',
            idNumber: document.getElementById('idNumber').value.trim(),
            fullName: document.getElementById('fullName').value.trim(),
            gender: gender === 'male' ? 'Nam' : 'Nữ',
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
        alert('Please add at least one insured person');
        return false;
    }
    return true;
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
        alert('Please fill in all required information (*)');
        return;
    }
    
    const person = {
        id: Date.now(),
        fullName,
        idNumber,
        gender: gender === 'male' ? 'male' : 'female',
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
    if (confirm('Are you sure you want to delete this person??')) {
        state.insuredPersons = state.insuredPersons.filter(p => p.id !== id);
        renderInsuredPersonsList();
        updateTotalAmount();
    }
}

function renderInsuredPersonsList() {
    const container = document.getElementById('insuredPersonsList');
    
    if (state.insuredPersons.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 40px;">No insured person yet. Click "Add Insured" button to add.</p>';
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
                    <span class="detail-label">Giới tính:</span>
                    <span class="detail-value">${person.gender}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Số CMND/CCCD:</span>
                    <span class="detail-value">${person.idNumber}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Ngày sinh:</span>
                    <span class="detail-value">${person.birthDate}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Số điện thoại:</span>
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
        <div class="detail-row"><span class="detail-label">Full name:</span><span class="detail-value">${state.buyerInfo.fullName}</span></div>
        <div class="detail-row"><span class="detail-label">Sex:</span><span class="detail-value">${state.buyerInfo.gender}</span></div>
        <div class="detail-row"><span class="detail-label">Document number:</span><span class="detail-value">${state.buyerInfo.idNumber}</span></div>
        <div class="detail-row"><span class="detail-label">Date of birth:</span><span class="detail-value">${state.buyerInfo.birthDate}</span></div>
        <div class="detail-row"><span class="detail-label">Phone number:</span><span class="detail-value">${state.buyerInfo.phoneNumber}</span></div>
        <div class="detail-row"><span class="detail-label">Email:</span><span class="detail-value">${state.buyerInfo.email}</span></div>
        <div class="detail-row"><span class="detail-label">Address:</span><span class="detail-value">${state.buyerInfo.address}</span></div>
    ` : `
        <div class="detail-row"><span class="detail-label">Organization name:</span><span class="detail-value">${state.buyerInfo.orgName}</span></div>
        <div class="detail-row"><span class="detail-label">Tax code:</span><span class="detail-value">${state.buyerInfo.taxCode}</span></div>
        <div class="detail-row"><span class="detail-label">Representative:</span><span class="detail-value">${state.buyerInfo.representative}</span></div>
        <div class="detail-row"><span class="detail-label">Phone number:</span><span class="detail-value">${state.buyerInfo.phoneNumber}</span></div>
        <div class="detail-row"><span class="detail-label">Email:</span><span class="detail-value">${state.buyerInfo.email}</span></div>
        <div class="detail-row"><span class="detail-label">Address:</span><span class="detail-value">${state.buyerInfo.address}</span></div>
    `;
    
    container.innerHTML = `
        <div class="confirmation-section">
            <h3 class="section-title">Insurance package information</h3>
            <div class="detail-row"><span class="detail-label">Tên gói:</span><span class="detail-value">${state.selectedPackage.name}</span></div>
            <div class="detail-row"><span class="detail-label">Ngày bắt đầu:</span><span class="detail-value">${state.startDate}</span></div>
            <div class="detail-row"><span class="detail-label">Ngày kết thúc:</span><span class="detail-value">${state.endDate}</span></div>
            <div class="detail-row"><span class="detail-label">Phí/người:</span><span class="detail-value">${formatCurrency(state.selectedPackage.price)} VNĐ</span></div>
        </div>
        
        <div class="confirmation-section">
            <h3 class="section-title">Insurance buyer information</h3>
            ${buyerInfoHtml}
        </div>
        
        <div class="confirmation-section">
            <h3 class="section-title">List of insured persons (${state.insuredPersons.length})</h3>
            ${state.insuredPersons.map((person, index) => `
                <div class="insured-summary">
                    <strong>${index + 1}. ${person.fullName}</strong> - ${person.gender} - ${person.idNumber}
                </div>
            `).join('')}
        </div>
    `;
}

function submitForm() {
    // Kiểm tra checkbox đồng ý điều khoản
    const agreeTerms = document.getElementById('agreeTerms');
    if (!agreeTerms.checked) {
        alert('Please agree to the personal data protection policy');
        return;
    }
    
    // Lấy InsuranceId từ URL
    const urlParams = new URLSearchParams(window.location.search);
    const insuranceId = urlParams.get('insuranceId') || urlParams.get('id');
    
    if (!insuranceId) {
        alert('Not found Insurance ID');
        return;
    }
    
    // Tạo form để submit
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'PurchaseInsurance'; // Thay đổi URL servlet của bạn
    
    // Thêm InsuranceId
    addHiddenField(form, 'insuranceId', insuranceId);
    
    // Thêm Type (package name)
    addHiddenField(form, 'type', state.selectedPackage.name);
    
    // Thêm StartDate và EndDate
    addHiddenField(form, 'startDate', state.startDate);
    addHiddenField(form, 'endDate', state.endDate);
    
    // Thêm TotalPrice
    const totalPrice = state.selectedPackage.price * state.insuredPersons.length;
    addHiddenField(form, 'totalPrice', totalPrice);
    
    // Thêm thông tin người mua bảo hiểm
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
    
    // Thêm danh sách người được bảo hiểm
    addHiddenField(form, 'travelersCount', state.insuredPersons.length);
    
    state.insuredPersons.forEach((person, index) => {
        addHiddenField(form, `traveler[${index}].fullName`, person.fullName);
        addHiddenField(form, `traveler[${index}].idNumber`, person.idNumber);
        addHiddenField(form, `traveler[${index}].gender`, person.gender);
        addHiddenField(form, `traveler[${index}].birthDate`, person.birthDate);
        addHiddenField(form, `traveler[${index}].phoneNumber`, person.phoneNumber);
        addHiddenField(form, `traveler[${index}].email`, person.email);
    });
    
    // Thêm form vào body và submit
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