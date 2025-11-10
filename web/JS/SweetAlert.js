// JS/alert.js

// Kiểm tra nếu có param success hoặc error
document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);

    if (urlParams.get('success') === 'true') {
        Swal.fire({
            icon: 'success',
            title: 'Mua hàng thành công!',
            text: 'Bảo hiểm của bạn đã được mua thành công.',
            confirmButtonText: 'OK'
        }).then(() => {
            clearParam('success');
        });
    }

    if (urlParams.get('error')) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: urlParams.get('error'),
            confirmButtonText: 'OK'
        }).then(() => {
            clearParam('error');
        });
    }

    function clearParam(paramName) {
        const url = new URL(window.location.href);
        url.searchParams.delete(paramName);
        window.history.replaceState({}, document.title, url);
    }
});
