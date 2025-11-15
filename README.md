# Learn Networking in iOS
https://www.youtube.com/watch?v=II7WcnHVG4U&t=4583s 

## View

```
class CoinsViewModel: ObservableObject {
```
Observable Object can publish changes so any other view observing it can automatically update itself when data changes

```
guard let url = URL(string: urlString) else { return }
```
tujuannya untuk: 
- convert it to url object
- URL is a struct defined in foundation library
- wrapper for CFURL from core foundation
- parse the string to structured component kayak scheme (https), host (example.com), path (/path), query (query=1), fragment, port, user, password
- pastiin stringnya valid as url


```
URLSession.shared.dataTask(with: url) { data, response, error in
```
 URL session
 - networking api nya apple yg open TCP connection, handle TLS, managing cookies, caching, redirect, retry, background download
 dataTask
 - bikin task object yg represent 1 http request/response
 - buat tau harus manggil url apa, http header, parse response, callback untuk jalanin ketika selesai
 - cara startnya dengan panggil .resume() karena ga start otomatis

 OSI layer
 - application: URLSession ambil URL dan siapin http request object (kalo https berarti butuh TLS encryption)
 - presentation: pake TLS, di layer ini perform handshake, certificate validation, encryption key negotiation, intinya di layer ini datanya di-encrypt sebelum meninggalkan device
 - session: pastiin socketnya alive, cookies dan session token, redirect or auth
 - transport: pake TCP yang open connection to server IP dan port, split http request ke packet dan pastiin sampe dgn baik
 - network: setiap paket dikasih alamat source sama destination
 - data link and physical: packet diubah jadi frame lalu ke electric/radio signal trs dikirim dari network adapter ke cell tower

 - data Task take time to get the data, jadi completion handler itu baru akan execute setelah datanya ready
 
 ```
DispatchQueue.main.async {
 ```
- pokoknya kalo mau update UI harus di dalem dispatch queue main
- jadi klo kita panggil function ini 2 kali, itu bakal nungguin sampe 1 kelar baru jalanin yang satunya lagi

```
guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
```
baca raw data, parse ke json standard, return array n dict
transform to dictionary


```
.resume()
```
klo pake completion handler harus pake resume. karena bikin data task bukan berarti kita start itu, jadi harus panggil resume agar start network call-nya
  
        

## Data Service

```
func fetchPrice(coin: String, completion: @escaping(Double) -> Void)
```
we cannot return value from completion handler because it is executed async, makanya kita bikin completion

```
@escaping(Double) -> Void
```
- escaping artinya kita mau closure ini tetap hidup walau functionnya udah di-return.
- (Double) -> Void artinya terima double dan return void

```
completion(price)
```
passing price into parameter completion

