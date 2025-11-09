 <?php

include "connect.php";
include "functions.php";

// رفع الصورة إلى السيرفر
$uploadDir = "upload/imageSearch";
$files = imageUpload($uploadDir, "files");

if ($files != "fail" && $files != "empty") {
    $image_path = $files;

    // التأكد إن الصورة موجودة فعلاً
    if (!file_exists($image_path)) {
        echo json_encode([
            "status" => "error",
            "message" => "❌ Image file not found locally!"
        ]);
        exit;
    }

    // تحويل الصورة إلى base64
    $image_data = base64_encode(file_get_contents($image_path));

    
    $post_data = json_encode([
        "image_base64" => $image_data,
        "k" => 2  // عدد النتائج المطلوبة
    ]);

   
    $ch = curl_init("http://192.168.141.157:8080/search");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    // معالجة الاستجابة
    $responseData = json_decode($response, true);

    if ($http_code != 200 || !$responseData) {
        echo json_encode([
            "status" => "error",
            "message" => "❌ Flask API failed",
            "response" => $response
        ]);
        exit;
    }
///static/


   
    $base_url = "http://192.168.141.157:8080/static/";

    if (isset($responseData["similar_images"])) {
        foreach ($responseData["similar_images"] as &$image) {
            $image = $base_url . str_replace("\\", "/", $image); // لو الصور جايه على شكل مسارات
        }
    }

   
    echo json_encode([
        "status" => "success",
        "message" => "✅ Image uploaded and sent to AI successfully!",
        "response" => $responseData
    ]);
}
?>
//Card Number :5123450000000008
//Card holder name : Fawaterak test
//Expiry Date : 12/26
//CSV:100