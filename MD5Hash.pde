public class MD5Hash
{
  public MD5Hash()
  {

  }
  
  private byte[] messageDigest(String message, String algorithm)
  {
    try
    {
      java.security.MessageDigest md = java.security.MessageDigest.getInstance(algorithm);
      md.update(message.getBytes());
      return md.digest();
    }
    catch(java.security.NoSuchAlgorithmException e)
    {
      println(e.getMessage());
      return null;
    }
  }
  
  private String hashString(String tweet)
  {
    byte[] md5hash = messageDigest(tweet,"MD5");
    String md5string="";
    for(int i=0; i<md5hash.length; i++)
    {
      md5string += (hex(md5hash[i],2));
      md5string += "";
    }
    return md5string.toLowerCase();
    //println("");
  }
}
