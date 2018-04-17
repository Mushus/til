# S3からストリーミングでファイルを配信する

ファイルを取得しきってから書き出すよりストリーミングしながら書き出した方が早いよねってことで。  
サンプルコードあれば楽なんだけど、良さげなのが無いっぽいので最小の動作確認済みコード  
正しい記述かまではあんまし検証してないので自己責任で。  
正直チャンク分けて取得してないからしっかり遅れてるか怪しい。  
phpのソース読んでないから `fpassthru` がいい感じにやってくれてるのか不明。  
この辺ノウハウほしい。  

Laravel 5.5

```php
class HogeController extends Controller
{
    public function image(Request $request, $name = "") {
        $name = urlencode($name);
        $path = "/$name.png";

        try {
            $disk = Storage::disk('s3');
            $stream = $disk->getDriver()->readStream($path);
            // s3のデータをストリーミングで配信する
            return response()->stream(function() use ($stream) {
                fpassthru($stream);
            }, 200, ['Content-Type' => 'image/png']);
        } catch(FileNotFoundException $e) {
            return response(view('errors/404'), 404);
        }
    }
}
```
