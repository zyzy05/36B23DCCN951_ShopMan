package vn.shopman.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public final class PasswordUtil {
    private PasswordUtil() {
    }

    // Creates the SHA-256 representation used by the bundled demo accounts.
    public static String sha256(String value) {
        try {
            byte[] bytes = MessageDigest
                    .getInstance("SHA-256")
                    .digest(value.getBytes(StandardCharsets.UTF_8));

            char[] hexDigits = "0123456789abcdef".toCharArray();
            StringBuilder result = new StringBuilder(bytes.length * 2);

            for (byte item : bytes) {
                int unsignedByte = item & 0xff;
                result.append(hexDigits[unsignedByte >>> 4]);
                result.append(hexDigits[unsignedByte & 0x0f]);
            }

            return result.toString();
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException(exception);
        }
    }
}
