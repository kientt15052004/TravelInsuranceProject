package Model;

/**
 * Constants for claim status values used across the app.
 */
public final class ClaimStatus {

    private ClaimStatus() {
    }

    public static final String PENDING = "pending";
    public static final String IN_PROGRESS = "in_progress";
    public static final String NEED_INFO = "need_info";
    public static final String APPROVED = "approved";
    public static final String REJECTED = "rejected";
    public static final String PAID = "paid";
}
