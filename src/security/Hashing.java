package security;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Hashing {
	public static String getMD5Hash(String str){
		MessageDigest m = null;
		try {
			m = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e);
		}
        m.update(str.getBytes(),0,str.length());
        String strHash = new BigInteger(1,m.digest()).toString(16);
		return strHash;		
	}
}
