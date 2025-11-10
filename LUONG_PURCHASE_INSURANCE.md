# Luồng Đi Của Purchase Insurance

## Tổng Quan
Luồng mua bảo hiểm hoạt động qua 3 lớp: **JSP (View) → JavaScript (Logic) → Controller (Backend)**

---

## 1. JSP (InsurancePurchase.jsp) - Lớp Hiển Thị

### Chức năng:
- Hiển thị form mua bảo hiểm với **5 bước**:
  1. **Chọn Gói Bảo Hiểm**: Ngày bắt đầu/kết thúc, chọn gói (1,000 - 20,000 VNĐ/người)
  2. **Thông Tin Người Mua**: CCCD, Họ tên, Giới tính, Ngày sinh, SĐT, Email, Địa chỉ
  3. **Người Được Bảo Hiểm**: Thêm/xóa danh sách người được bảo hiểm
  4. **Xác Nhận**: Hiển thị tóm tắt thông tin đã nhập
  5. **Thanh Toán**: Nhập thông tin thẻ (Tên chủ thẻ, Số thẻ, Ngày hết hạn, CVV)

### Dữ liệu từ Controller:
```jsp
${requestScope.insurance}      // Thông tin sản phẩm bảo hiểm
${requestScope.insurance.benefit}  // Quyền lợi bảo hiểm
${sessionScope.user}           // Thông tin user đã đăng nhập
```

### Biến JavaScript được khởi tạo:
```jsp
const INSURANCE_TYPE = '${requestScope.insurance.type}';
const BENEFIT_ID = '${requestScope.insurance.benefit_id}';
```

---

## 2. JavaScript (InsurancePurchase.js) - Lớp Logic & Validation

### State Management:
```javascript
let state = {
    selectedPackage: { price, benefit, name },
    startDate, endDate,
    buyerInfo: { type, idNumber, fullName, ... },
    insuredPersons: [...],
    paymentInfo: { cardholderName, cardNumber, ... }
};
```

### Luồng xử lý:

#### **Bước 1-4: Thu thập & Validate dữ liệu**
- `handleContinue()`: Xử lý nút "Tiếp Tục" ở mỗi bước
- `validateStep1()` → `validateStep5()`: Kiểm tra dữ liệu hợp lệ
- `saveBuyerInfo()`: Lưu thông tin người mua vào state
- `saveInsuredPerson()`: Thêm người được bảo hiểm vào state
- `updateTotalAmount()`: Tính tổng tiền = giá gói × số người × số ngày

#### **Bước 5: Submit Form**
```javascript
function submitForm() {
    // 1. Lấy insuranceId từ URL
    const insuranceId = urlParams.get('insuranceId') || urlParams.get('id');
    
    // 2. Tạo form ẩn (hidden form)
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'purchase-insurance';  // URL pattern của Controller
    
    // 3. Thêm tất cả dữ liệu vào hidden fields
    addHiddenField(form, 'insuranceId', insuranceId);
    addHiddenField(form, 'startDate', state.startDate);
    addHiddenField(form, 'endDate', state.endDate);
    addHiddenField(form, 'totalPrice', totalPrice);
    addHiddenField(form, 'buyerFullName', state.buyerInfo.fullName);
    // ... thêm tất cả thông tin người mua, người được bảo hiểm, thanh toán
    
    // 4. Submit form → Gửi POST request đến Controller
    form.submit();
}
```

---

## 3. Controller (PurchaseInsuranceController.java) - Lớp Backend

### doGet() - Hiển thị trang mua bảo hiểm:
```java
1. Kiểm tra user đã đăng nhập (session)
2. Lấy insuranceId từ request parameter "id"
3. Lấy thông tin bảo hiểm từ database
4. Set attribute: insurance, benefits
5. Forward đến InsurancePurchase.jsp
```

### doPost() - Xử lý mua bảo hiểm:

#### **Bước 1: Lấy Parameters từ Form**
```java
String insuranceIdStr = request.getParameter("insuranceId");
String startDateStr = request.getParameter("startDate");
String endDateStr = request.getParameter("endDate");
String totalPriceStr = request.getParameter("totalPrice");
String buyerFullName = request.getParameter("buyerFullName");
// ... lấy tất cả thông tin từ form
```

#### **Bước 2: Validate & Parse**
```java
- Parse insuranceId, benefitId, travelerQuantity
- Parse totalPrice → BigDecimal
- Parse startDate, endDate → Date
- Validate thông tin thanh toán (card number, expiry date)
```

#### **Bước 3: Tạo Objects**
```java
// Tạo Application
Application app = new Application();
app.setPurchaser_id(user.getId());
app.setProduct_id(insuranceId);
app.setStartDate(startDate);
app.setEndDate(endDate);
app.setTotal_price(totalPrice);

// Tạo BuyerInfo
BuyerInfo buyerInfo = new BuyerInfo();
buyerInfo.setFullName(buyerFullName);
// ... set các thông tin khác

// Tạo danh sách Travelers
List<ApplicationTraveler> travelers = new ArrayList<>();
for (int i = 0; i < travelerQuantity; i++) {
    ApplicationTraveler traveler = new ApplicationTraveler();
    traveler.setName(request.getParameter("traveler[" + i + "].fullName"));
    // ... set thông tin từng người
    travelers.add(traveler);
}

// Tạo Contract
Contract contract = new Contract();
contract.setStartDate(startDate);
contract.setEndDate(endDate);
contract.setTotalPrice(totalPrice);

// Tạo Invoice
Invoice invoice = new Invoice();
invoice.setBase_amount(totalPrice);
invoice.setPayment_method("bank_transfer");
```

#### **Bước 4: Thực hiện Transaction**
```java
InvoiceDBContext pdb = new InvoiceDBContext();
int result = pdb.processInsurancePurchaseTransaction(
    app, travelers, contract, invoice
);
```

#### **Bước 5: Redirect**
```java
if (result > 0) {
    // Thành công → redirect về danh sách với thông báo
    response.sendRedirect("insurance-list?success=true&contractId=" + contractId);
} else {
    // Thất bại → redirect với thông báo lỗi
    response.sendRedirect("insurance-list?error=" + errorMessage);
}
```

---

## Sơ Đồ Luồng Đi

```
┌─────────────────────────────────────────────────────────────┐
│ 1. USER TRUY CẬP /PurchaseInsurance?id=1                   │
│    → Controller.doGet()                                     │
│    → Lấy thông tin bảo hiểm từ DB                          │
│    → Forward đến InsurancePurchase.jsp                      │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. JSP HIỂN THỊ FORM (5 bước)                              │
│    → InsurancePurchase.jsp                                  │
│    → Load InsurancePurchase.js                              │
│    → Khởi tạo state object                                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. USER ĐIỀN FORM (Bước 1-5)                               │
│    → JavaScript xử lý:                                      │
│      • validateStep1() - validateStep5()                   │
│      • saveBuyerInfo()                                      │
│      • saveInsuredPerson()                                  │
│      • updateTotalAmount()                                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. USER NHẤN "TIẾP TỤC" Ở BƯỚC 5                           │
│    → submitForm() trong JS                                  │
│    → Tạo hidden form với tất cả dữ liệu                   │
│    → POST đến 'purchase-insurance'                         │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. CONTROLLER XỬ LÝ                                         │
│    → PurchaseInsuranceController.doPost()                   │
│    → Lấy parameters từ request                             │
│    → Validate & Parse dữ liệu                               │
│    → Tạo Application, BuyerInfo, Travelers, Contract, Invoice│
│    → Gọi processInsurancePurchaseTransaction()             │
│    → Lưu vào database                                       │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. REDIRECT VỀ DANH SÁCH                                    │
│    → Nếu thành công: insurance-list?success=true            │
│    → Nếu thất bại: insurance-list?error=...                 │
│    → SweetAlert.js hiển thị thông báo                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Điểm Quan Trọng

1. **JSP**: Chỉ hiển thị, không xử lý logic
2. **JavaScript**: Xử lý toàn bộ logic phía client (validation, state management, form submission)
3. **Controller**: Xử lý phía server (validate, tạo objects, lưu database)
4. **Form Submission**: Sử dụng hidden form thay vì AJAX để đảm bảo dữ liệu được gửi đầy đủ
5. **Transaction**: Tất cả dữ liệu được lưu trong 1 transaction để đảm bảo tính nhất quán

