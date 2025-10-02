// State management
let state = {
    passengers: 1,
    selectedPackage: null,
    startDate: '',
    endDate: ''
};

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    initPackageSelection();
    initPassengerSelect();
    initDateInputs();
    initBottomBar();
    
    // Set default selected package (Plane)
    const planePackage = document.querySelector('.package-card.selected');
    if (planePackage) {
        selectPackage(planePackage);
    }
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
    // Remove selected class from all cards
    document.querySelectorAll('.package-card').forEach(card => {
        card.classList.remove('selected');
    });
    
    // Add selected class to clicked card
    selectedCard.classList.add('selected');
    
    // Update state
    const price = selectedCard.getAttribute('data-price');
    const benefit = selectedCard.getAttribute('data-benefit');
    state.selectedPackage = {
        price: parseInt(price),
        benefit: benefit,
        name: selectedCard.querySelector('.package-name').textContent
    };
    
    // Update total amount
    updateTotalAmount();
    
    // Update benefits display
    updateBenefitsDisplay(benefit);
}

// Update total amount display
function updateTotalAmount() {
    const totalElement = document.getElementById('totalAmount');
    if (state.selectedPackage) {
        const total = state.selectedPackage.price * state.passengers;
        totalElement.textContent = formatCurrency(total) + ' VNĐ';
    }
}

// Format currency
function formatCurrency(amount) {
    return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// Update benefits display based on selected package
function updateBenefitsDisplay(benefit) {
    const benefits = [
        { multiplier: 1, text: 'Death, permanent disability, temporary disability' },
        { multiplier: 0.5, text: 'Death due to illness, disease' },
        { multiplier: 0.5, text: 'Personal Liability to Third Parties' },
        { multiplier: 0.1, text: 'Lost Bank Card' },
        { multiplier: 0.2, text: 'Kidnapping and Hostage' },
        { multiplier: 0.05, text: 'Lost or Damaged Golf Equipment' }
    ];
    
    const benefitItems = document.querySelectorAll('.benefit-item');
    const baseBenefit = parseInt(benefit) * 1000000; // Convert to full amount
    
    benefitItems.forEach((item, index) => {
        if (benefits[index]) {
            const amount = baseBenefit * benefits[index].multiplier;
            const amountElement = item.querySelector('.benefit-amount');
            amountElement.textContent = formatCurrency(amount) + ' VNĐ';
        }
    });
}

// Passenger Selection
function initPassengerSelect() {
    const passengerBtn = document.getElementById('passengerBtn');
    const passengerText = document.getElementById('passengerText');
    
    passengerBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        showPassengerModal();
    });
}

function showPassengerModal() {
    const count = prompt('Enter number of passengers (1-10):', state.passengers);
    if (count !== null) {
        const num = parseInt(count);
        if (num >= 1 && num <= 10) {
            state.passengers = num;
            updatePassengerDisplay();
            updateTotalAmount();
        } else {
            alert('Please enter a number between 1 and 10');
        }
    }
}

function updatePassengerDisplay() {
    const passengerText = document.getElementById('passengerText');
    passengerText.textContent = `${state.passengers} Passenger${state.passengers > 1 ? 's' : ''}`;
}

// Date Inputs
function initDateInputs() {
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const swapBtn = document.querySelector('.swap-btn');
    
    // Set today's date as default
    const today = new Date().toISOString().split('T')[0];
    startDateInput.type = 'date';
    endDateInput.type = 'date';
    startDateInput.value = today;
    endDateInput.value = today;
    
    startDateInput.addEventListener('change', function() {
        state.startDate = this.value;
        validateDates();
    });
    
    endDateInput.addEventListener('change', function() {
        state.endDate = this.value;
        validateDates();
    });
    
    if (swapBtn) {
        swapBtn.addEventListener('click', function() {
            const temp = startDateInput.value;
            startDateInput.value = endDateInput.value;
            endDateInput.value = temp;
            
            const tempState = state.startDate;
            state.startDate = state.endDate;
            state.endDate = tempState;
        });
    }
}

function validateDates() {
    if (state.startDate && state.endDate) {
        const start = new Date(state.startDate);
        const end = new Date(state.endDate);
        const diffDays = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
        
        if (diffDays > 180) {
            alert('Insurance period cannot exceed 180 days');
        } else if (diffDays < 0) {
            alert('End date must be after start date');
        }
    }
}

// Bottom Bar Actions
function initBottomBar() {
    const backBtn = document.querySelector('.back-btn');
    const continueBtn = document.querySelector('.continue-btn');
    
    backBtn.addEventListener('click', function() {
        if (confirm('Are you sure you want to go back? Your current selection will be lost.')) {
            window.history.back();
        }
    });
    
    continueBtn.addEventListener('click', function() {
        if (validateForm()) {
            proceedToNextStep();
        }
    });
}

function validateForm() {
    if (!state.startDate) {
        alert('Please select insurance start date');
        return false;
    }
    
    if (!state.endDate) {
        alert('Please select insurance end date');
        return false;
    }
    
    if (!state.selectedPackage) {
        alert('Please select an insurance package');
        return false;
    }
    
    return true;
}

function proceedToNextStep() {
    console.log('Proceeding with:', state);
    
    // Show summary
    const summary = `
        Insurance Package: ${state.selectedPackage.name}
        Number of Passengers: ${state.passengers}
        Start Date: ${state.startDate}
        End Date: ${state.endDate}
        Total Amount: ${formatCurrency(state.selectedPackage.price * state.passengers)} VNĐ
    `;
    
    alert('Form submitted successfully!\n\n' + summary);
    
    // In a real application, you would navigate to the next page or submit the form
    // window.location.href = 'next-step.html';
}

// Utility function to format date
function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return `${month}/${day}/${year}`;
}

// Export state for debugging (optional)
window.insuranceState = state;