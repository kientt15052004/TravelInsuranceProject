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
        
        let currentPage = 1;
        let pageSize = parseInt(limitSelect.value) || 5;
        let start = 0;
        let end = 0;
        
        function renderTable() {
            // Hide all rows
            rows.forEach(row => row.style.display = 'none');
            
            // Show rows for current page
            start = (currentPage - 1) * pageSize;
            end = start + pageSize;
            rows.slice(start, end).forEach(row => row.style.display = '');
            
            renderPagination();
        }
        
        function renderPagination() {
            const totalPages = Math.ceil(rows.length / pageSize);
            paginationContainer.innerHTML = '';
            
            if (totalPages <= 1) {
                paginationContainer.innerHTML = `<span class="pagination-info">Hiển thị ${rows.length} kết quả</span>`;
                return;
            }
            
            // Previous button
            const prevBtn = document.createElement('button');
            prevBtn.className = 'page-btn';
            prevBtn.textContent = '‹';
            prevBtn.disabled = currentPage === 1;
            prevBtn.addEventListener('click', () => {
                if (currentPage > 1) {
                    currentPage--;
                    renderTable();
                }
            });
            paginationContainer.appendChild(prevBtn);
            
            // Page numbers
            const startPage = Math.max(1, currentPage - 2);
            const endPage = Math.min(totalPages, currentPage + 2);
            
            if (startPage > 1) {
                const firstBtn = document.createElement('button');
                firstBtn.className = 'page-btn';
                firstBtn.textContent = '1';
                firstBtn.addEventListener('click', () => {
                    currentPage = 1;
                    renderTable();
                });
                paginationContainer.appendChild(firstBtn);
                
                if (startPage > 2) {
                    const ellipsis = document.createElement('span');
                    ellipsis.textContent = '...';
                    ellipsis.style.padding = '0 8px';
                    paginationContainer.appendChild(ellipsis);
                }
            }
            
            for (let i = startPage; i <= endPage; i++) {
                const pageBtn = document.createElement('button');
                pageBtn.className = 'page-btn';
                if (i === currentPage) pageBtn.classList.add('active');
                pageBtn.textContent = i;
                pageBtn.addEventListener('click', () => {
                    currentPage = i;
                    renderTable();
                });
                paginationContainer.appendChild(pageBtn);
            }
            
            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    const ellipsis = document.createElement('span');
                    ellipsis.textContent = '...';
                    ellipsis.style.padding = '0 8px';
                    paginationContainer.appendChild(ellipsis);
                }
                
                const lastBtn = document.createElement('button');
                lastBtn.className = 'page-btn';
                lastBtn.textContent = totalPages;
                lastBtn.addEventListener('click', () => {
                    currentPage = totalPages;
                    renderTable();
                });
                paginationContainer.appendChild(lastBtn);
            }
            
            // Next button
            const nextBtn = document.createElement('button');
            nextBtn.className = 'page-btn';
            nextBtn.textContent = '›';
            nextBtn.disabled = currentPage === totalPages;
            nextBtn.addEventListener('click', () => {
                if (currentPage < totalPages) {
                    currentPage++;
                    renderTable();
                }
            });
            paginationContainer.appendChild(nextBtn);
            
            // Info text
            const info = document.createElement('span');
            info.className = 'pagination-info';
            info.textContent = `Hiển thị ${start + 1}-${Math.min(end, rows.length)} trong ${rows.length} kết quả`;
            paginationContainer.appendChild(info);
        }
        
        // Handle limit change
        limitSelect.addEventListener('change', function() {
            pageSize = parseInt(this.value) || 10;
            currentPage = 1;
            renderTable();
        });
        
        // Initial render
        renderTable();
    });
}

