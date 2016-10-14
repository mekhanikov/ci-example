
String jobUrl = "http://jkmaster.prod.noaccess.notribe.ydev.hybris.com:9080/createItem?name=AA_TEST_JOB78"
String superPomFile = "seedJob.xml"

HttpURLConnection httpUrlConnection;
URL url = new URL(jobUrl);
httpUrlConnection = (HttpURLConnection) url.openConnection();
httpUrlConnection.setUseCaches(false);
httpUrlConnection.setDoInput(true);
httpUrlConnection.setDoOutput(true);

httpUrlConnection.setRequestMethod("POST");
httpUrlConnection.setRequestProperty("Connection", "Keep-Alive");
httpUrlConnection.setRequestProperty("Cache-Control", "no-cache");
httpUrlConnection.setRequestProperty(
        "Content-Type", "application/xml");

PrintWriter pw = new PrintWriter(httpUrlConnection.getOutputStream());
pw.write(new File(superPomFile).text);

pw.close();
//BufferedInputStream bis = new BufferedInputStream(httpUrlConnection.getInputStream());
//bis.close();

//// Get response:
//InputStream responseStream = new
//        BufferedInputStream(httpUrlConnection.getInputStream());
//
//BufferedReader responseStreamReader =
//        new BufferedReader(new InputStreamReader(responseStream));
//
//String line = "";
//StringBuilder stringBuilder = new StringBuilder();
//
//while ((line = responseStreamReader.readLine()) != null) {
//    stringBuilder.append(line).append("\n");
//}
//responseStreamReader.close();
//
//String response = stringBuilder.toString();
//
//// Close response stream:
//responseStream.close();

// Get response:
InputStream responseStream = new
        BufferedInputStream(httpUrlConnection.getInputStream());

BufferedReader responseStreamReader =
        new BufferedReader(new InputStreamReader(responseStream));

String line = "";
StringBuilder stringBuilder = new StringBuilder();

while ((line = responseStreamReader.readLine()) != null) {
    stringBuilder.append(line).append("\n");
}
responseStreamReader.close();

String response = stringBuilder.toString();
println response
// Close response stream:
responseStream.close();
httpUrlConnection.disconnect();
