// Form Validation cho Profile Modal
function validateProfileForm(event) {
    const form = event.target;
    let isValid = true;

    // Clear all previous errors
    clearAllErrors(form);

    // Validate Họ và Tên
    const fullname = form.fullname.value.trim();
    if (!fullname) {
        showFieldError(form.fullname, 'Họ và tên không được để trống');
        isValid = false;
    }

    // Validate Email
    const email = form.mail.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email) {
        showFieldError(form.mail, 'Email không được để trống');
        isValid = false;
    } else if (!emailRegex.test(email)) {
        showFieldError(form.mail, 'Email không đúng định dạng');
        isValid = false;
    }
    
    // Validate address
    const address = form.address.value.trim();
    if (!address) {
        showFieldError(form.address, 'Địa chỉ không được để trống');
        isValid = false;
    }

    // Validate Ngày sinh
    const dob = form.dob.value;
    if (dob) {
        const birthDate = new Date(dob);
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        if (birthDate >= today) {
            showFieldError(form.dob, 'Ngày sinh không được là ngày tương lai');
            isValid = false;
        } else {
            // Kiểm tra tuổi hợp lý (không quá 150 tuổi)
            const age = today.getFullYear() - birthDate.getFullYear();
            if (age > 150) {
                showFieldError(form.dob, 'Ngày sinh không hợp lý');
                isValid = false;
            }
        }
    }

    // Validate Số điện thoại
    const phone = form.phone.value.trim();
    const phoneRegex = /^\d{10,15}$/;
    if (!phone) {
        showFieldError(form.phone, 'Số điện thoại không được để trống');
        isValid = false;
    } else if (!phoneRegex.test(phone)) {
        showFieldError(form.phone, 'Số điện thoại phải là số từ 10-15 chữ số');
        isValid = false;
    }

    // Validate CCCD
    const cccd = form.cccd.value.trim();
    const cccdRegex = /^\d{12}$/;
    if (!cccd) {
        showFieldError(form.cccd, 'Số CCCD không được để trống');
        isValid = false;
    } else if (!cccdRegex.test(cccd)) {
        showFieldError(form.cccd, 'Số CCCD phải là 12 chữ số');
        isValid = false;
    }

    // Prevent submit if invalid
    if (!isValid) {
        event.preventDefault();
        // Focus on first error field
        const firstError = form.querySelector('.is-invalid');
        if (firstError) {
            firstError.focus();
        }
    }

    return isValid;
}

// Form Validation cho Change Password Modal
function validatePasswordForm(event) {
    const form = event.target;
    let isValid = true;

    // Clear all previous errors
    clearAllErrors(form);

    // Validate Mật khẩu hiện tại
    const currentPassword = form.currentPassword.value;
    if (!currentPassword) {
        showFieldError(form.currentPassword, 'Mật khẩu hiện tại không được để trống');
        isValid = false;
    }

    // Validate Mật khẩu mới
    const newPassword = form.newPassword.value;
    if (!newPassword) {
        showFieldError(form.newPassword, 'Mật khẩu mới không được để trống');
        isValid = false;
    } else if (newPassword.length < 6) {
        showFieldError(form.newPassword, 'Mật khẩu mới phải có ít nhất 6 ký tự');
        isValid = false;
    }

    // Validate Xác nhận mật khẩu
    const confirmPassword = form.confirmPassword.value;
    if (!confirmPassword) {
        showFieldError(form.confirmPassword, 'Xác nhận mật khẩu không được để trống');
        isValid = false;
    } else if (newPassword && newPassword !== confirmPassword) {
        showFieldError(form.confirmPassword, 'Mật khẩu mới và xác nhận mật khẩu không khớp');
        isValid = false;
    }

    // Kiểm tra mật khẩu mới khác mật khẩu cũ
    if (currentPassword && newPassword && currentPassword === newPassword) {
        showFieldError(form.newPassword, 'Mật khẩu mới phải khác mật khẩu hiện tại');
        isValid = false;
    }

    // Prevent submit if invalid
    if (!isValid) {
        event.preventDefault();
        // Focus on first error field
        const firstError = form.querySelector('.is-invalid');
        if (firstError) {
            firstError.focus();
        }
    }

    return isValid;
}

// Validate file upload (avatar và CCCD image)
function validateFileUpload(input, maxSizeMB = 5) {
    const file = input.files[0];
    if (file) {
        // Kiểm tra định dạng file
        const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
        if (!allowedTypes.includes(file.type)) {
            showFieldError(input, 'Chỉ chấp nhận file ảnh định dạng JPG, JPEG, PNG, GIF');
            input.value = '';
            return false;
        }

        // Kiểm tra kích thước file
        const maxSize = maxSizeMB * 1024 * 1024; // Convert MB to bytes
        if (file.size > maxSize) {
            showFieldError(input, `Kích thước file không được vượt quá ${maxSizeMB}MB`);
            input.value = '';
            return false;
        }
    }
    return true;
}

// Real-time validation cho các input
function setupRealtimeValidation() {
    // Validate số điện thoại
    const phoneInput = document.querySelector('input[name="phone"]');
    if (phoneInput) {
        phoneInput.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, ''); // Chỉ cho phép số
            if (this.value.length > 15) {
                this.value = this.value.slice(0, 15);
            }
            // Remove error when user starts typing
            if (this.value) {
                removeFieldError(this);
                this.classList.remove('is-invalid');
            }
        });

        phoneInput.addEventListener('blur', function () {
            if (this.value && (this.value.length < 10 || this.value.length > 15)) {
                this.classList.add('is-invalid');
                showFieldError(this, 'Số điện thoại phải từ 10-15 chữ số');
            } else if (this.value) {
                this.classList.remove('is-invalid');
                removeFieldError(this);
            }
        });
    }

    // Validate CCCD
    const cccdInput = document.querySelector('input[name="cccd"]');
    if (cccdInput) {
        cccdInput.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, ''); // Chỉ cho phép số
            if (this.value.length > 12) {
                this.value = this.value.slice(0, 12);
            }
            // Remove error when user starts typing
            if (this.value) {
                removeFieldError(this);
                this.classList.remove('is-invalid');
            }
        });

        cccdInput.addEventListener('blur', function () {
            if (this.value && this.value.length !== 12) {
                this.classList.add('is-invalid');
                showFieldError(this, 'Số CCCD phải là 12 chữ số');
            } else if (this.value) {
                this.classList.remove('is-invalid');
                removeFieldError(this);
            }
        });
    }

    // Validate Email
    const emailInput = document.querySelector('input[name="mail"]');
    if (emailInput) {
        emailInput.addEventListener('input', function () {
            // Remove error when user starts typing
            if (this.value) {
                removeFieldError(this);
                this.classList.remove('is-invalid');
            }
        });

        emailInput.addEventListener('blur', function () {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (this.value && !emailRegex.test(this.value)) {
                this.classList.add('is-invalid');
                showFieldError(this, 'Email không đúng định dạng');
            } else if (this.value) {
                this.classList.remove('is-invalid');
                removeFieldError(this);
            }
        });
    }

    // Validate Ngày sinh
    const dobInput = document.querySelector('input[name="dob"]');
    if (dobInput) {
        dobInput.addEventListener('change', function () {
            if (this.value) {
                const birthDate = new Date(this.value);
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                if (birthDate >= today) {
                    this.classList.add('is-invalid');
                    showFieldError(this, 'Ngày sinh không được là ngày tương lai');
                } else {
                    this.classList.remove('is-invalid');
                    removeFieldError(this);
                }
            }
        });
    }

    // Validate fullname
    const fullnameInput = document.querySelector('input[name="fullname"]');
    if (fullnameInput) {
        fullnameInput.addEventListener('input', function () {
            if (this.value.trim()) {
                removeFieldError(this);
                this.classList.remove('is-invalid');
            }
        });
    }

    // Validate password fields
    const passwordFields = ['currentPassword', 'newPassword', 'confirmPassword'];
    passwordFields.forEach(fieldName => {
        const field = document.querySelector(`input[name="${fieldName}"]`);
        if (field) {
            field.addEventListener('input', function () {
                if (this.value) {
                    removeFieldError(this);
                    this.classList.remove('is-invalid');
                }
            });
        }
    });
}

// Helper functions để hiển thị/xóa lỗi field
function showFieldError(field, message) {
    removeFieldError(field);
    field.classList.add('is-invalid');
    const errorDiv = document.createElement('div');
    errorDiv.className = 'invalid-feedback d-block';
    errorDiv.style.color = '#dc3545';
    errorDiv.style.fontSize = '0.875rem';
    errorDiv.style.marginTop = '0.25rem';
    errorDiv.textContent = message;
    field.parentNode.appendChild(errorDiv);
}

function removeFieldError(field) {
    const existingError = field.parentNode.querySelector('.invalid-feedback');
    if (existingError) {
        existingError.remove();
    }
    field.classList.remove('is-invalid');
}

function clearAllErrors(form) {
    const errorMessages = form.querySelectorAll('.invalid-feedback');
    errorMessages.forEach(error => error.remove());
    
    const invalidFields = form.querySelectorAll('.is-invalid');
    invalidFields.forEach(field => field.classList.remove('is-invalid'));
}

// Khởi tạo validation khi document ready
document.addEventListener('DOMContentLoaded', function () {
    // Gắn validation vào form profile
    const profileForm = document.querySelector('#profileModal form');
    if (profileForm) {
        profileForm.addEventListener('submit', validateProfileForm);
    }

    // Gắn validation vào form change password
    const passwordForm = document.querySelector('#changePasswordModal form');
    if (passwordForm) {
        passwordForm.addEventListener('submit', validatePasswordForm);
    }

    // Setup real-time validation
    setupRealtimeValidation();

    // Validate file uploads
    const avatarInput = document.querySelector('input[name="avatar"]');
    if (avatarInput) {
        avatarInput.addEventListener('change', function () {
            if (validateFileUpload(this, 5)) {
                previewImage(this, 'avatarPreview');
            }
        });
    }

    const cccdImgInput = document.querySelector('input[name="cccd_img"]');
    if (cccdImgInput) {
        cccdImgInput.addEventListener('change', function () {
            if (validateFileUpload(this, 5)) {
                previewImage(this, 'cccdPreview');
            }
        });
    }
});