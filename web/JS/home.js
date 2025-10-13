/**
 * Hàm toggleFAQ - Mở/đóng câu trả lời khi click vào câu hỏi
 * 1. Kiểm tra xem câu hỏi hiện tại có đang mở không
 * 2. Đóng tất cả các câu hỏi khác
 * 3. Mở câu hỏi được click (nếu nó chưa mở)
 * @param {HTMLElement} element - Phần tử FAQ item được click
 */
function toggleFAQ(element) {
    // Kiểm tra xem item hiện tại có class 'active' không (đang mở hay đóng)
    const isActive = element.classList.contains('active');
    
    // Lấy tất cả các FAQ items trên trang
    const allFaqItems = document.querySelectorAll('.faq-item');
    
    // Đóng tất cả các FAQ items (xóa class 'active' khỏi tất cả)
    allFaqItems.forEach(item => {
        item.classList.remove('active');
    });
    
    // Nếu item chưa mở thì mở nó (thêm class 'active')
    // Nếu item đã mở thì giữ nguyên trạng thái đóng (không làm gì)
    if (!isActive) {
        element.classList.add('active');
    }
}

// ===== KHỞI TẠO KHI TRANG LOAD XONG =====
/**
 * Đợi trang web load hoàn toàn trước khi thực hiện các function
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('Trang home đã load xong!');
    
    // Có thể thêm các function khác ở đây khi cần
    // Ví dụ: Smooth scroll, form validation, etc.
});