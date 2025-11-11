// Admin Dashboard JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize date pickers
    initDatePickers();
    
    // Initialize table pagination
    initTablePagination();
    
    // Format currency on page load
    formatCurrency();
    
    // Format percentages
    formatPercentages();
    
    // Scroll to claims result if exists (after form submission)
    scrollToClaimsResult();
});

/**
 * Initialize date pickers with default values if not set
 */
function initDatePickers() {
    const fromDateInput = document.querySelector('input[name="fromDate"]');
    const toDateInput = document.querySelector('input[name="toDate"]');
    
    if (fromDateInput && !fromDateInput.value) {
        // Set default to 30 days ago
        const date = new Date();
        date.setDate(date.getDate() - 30);
        fromDateInput.value = formatDateForInput(date);
    }
    
    if (toDateInput && !toDateInput.value) {
        // Set default to today
        toDateInput.value = formatDateForInput(new Date());
    }
}

/**
 * Format date for input type="date"
 */
function formatDateForInput(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

/**
 * Format currency values
 */
function formatCurrency() {
    // This is handled by JSTL fmt:formatNumber in JSP
    // But we can add client-side formatting if needed
}

/**
 * Format percentage values
 */
function formatPercentages() {
    // This is handled by JSTL fmt:formatNumber in JSP
    // But we can add client-side formatting if needed
}

/**
 * Validate date range
 */
function validateDateRange(fromDate, toDate) {
    if (fromDate && toDate) {
        const from = new Date(fromDate);
        const to = new Date(toDate);
        
        if (from > to) {
            alert('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc!');
            return false;
        }
    }
    return true;
}

/**
 * Handle form submission for staff approval filter
 */
document.addEventListener('submit', function(e) {
    const form = e.target;
    if (form && form.querySelector('input[name="action"][value="staffApproval"]')) {
        const fromDate = form.querySelector('input[name="fromDate"]').value;
        const toDate = form.querySelector('input[name="toDate"]').value;
        
        if (!validateDateRange(fromDate, toDate)) {
            e.preventDefault();
            return false;
        }
    }
    
    if (form && form.querySelector('input[name="action"][value="customerRisk"]')) {
        const minContracts = form.querySelector('input[name="minContracts"]').value;
        const days = form.querySelector('input[name="days"]').value;
        
        if (minContracts && parseInt(minContracts) < 1) {
            alert('Số hợp đồng tối thiểu phải lớn hơn 0!');
            e.preventDefault();
            return false;
        }
        
        if (days && parseInt(days) < 1) {
            alert('Số ngày phải lớn hơn 0!');
            e.preventDefault();
            return false;
        }
    }
});

/**
 * Show loading state on form submission
 */
document.addEventListener('submit', function(e) {
    const form = e.target;
    const submitButton = form.querySelector('button[type="submit"]');
    
    if (submitButton) {
        submitButton.disabled = true;
        submitButton.textContent = 'Đang xử lý...';
    }
});

/**
 * Initialize table pagination for all tables
 * Note: This is now simplified - server already limits the data, so we just display what's loaded
 */
function initTablePagination() {
    const tables = document.querySelectorAll('.stats-table');
    
    tables.forEach((table, index) => {
        const tbody = table.querySelector('tbody');
        if (!tbody) return;
        
        const rows = Array.from(tbody.querySelectorAll('tr:not(.empty-state)'));
        if (rows.length === 0) return;
        
        const paginationContainer = table.closest('.table-section').querySelector('.table-pagination');
        if (!paginationContainer) return;
        
        const limitSelect = table.closest('.table-section').querySelector('.table-limit-select');
        if (!limitSelect) return;
        
        // Show all rows (server already limited the data)
        rows.forEach(row => row.style.display = '');
        
        // Display info text only (no pagination controls needed since server handles limiting)
        paginationContainer.innerHTML = `<span class="pagination-info">Hiển thị ${rows.length} kết quả</span>`;
        
        // Handle limit change - Reload page with new limit parameter
        limitSelect.addEventListener('change', function() {
            const newLimit = parseInt(this.value) || 5;
            const currentUrl = new URL(window.location.href);
            
            // Update URL with the new limit
            currentUrl.searchParams.set('limit', newLimit);
            
            // Preserve other parameters (fromDate, toDate, staffId, etc.)
            const urlParams = new URLSearchParams(window.location.search);
            ['fromDate', 'toDate', 'staffId', 'action'].forEach(param => {
                if (urlParams.has(param)) {
                    currentUrl.searchParams.set(param, urlParams.get(param));
                }
            });
            
            // Reload page with new limit
            window.location.href = currentUrl.toString();
        });
    });
}

/**
 * Scroll to claims result section if it exists
 * This happens after form submission when claimsByStaff is loaded
 */
function scrollToClaimsResult() {
    const claimsResultSection = document.getElementById('claimsByStaffResult');
    if (claimsResultSection) {
        // Add a highlight animation
        claimsResultSection.style.animation = 'highlight 2s ease-in-out';
        
        // Scroll to the section with smooth behavior
        setTimeout(() => {
            claimsResultSection.scrollIntoView({ 
                behavior: 'smooth', 
                block: 'start' 
            });
        }, 100);
        
        // Remove animation after it completes
        setTimeout(() => {
            claimsResultSection.style.animation = '';
        }, 2000);
    }
}

