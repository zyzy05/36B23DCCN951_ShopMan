package vn.shopman.model;

public class Customer1 {
    private final int customerId;
    private final String customerCode;
    private final String fullName;
    private final String phone;
    private final String email;
    private final String address;

    public Customer1(int customerId, String customerCode, String fullName,
                     String phone, String email, String address) {
        this.customerId = customerId;
        this.customerCode = customerCode;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
    }

    public int getCustomerId() { return customerId; }
    public String getCustomerCode() { return customerCode; }
    public String getFullName() { return fullName; }
    public String getPhone() { return phone; }
    public String getEmail() { return email; }
    public String getAddress() { return address; }
}
