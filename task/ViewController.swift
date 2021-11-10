//
//  ViewController.swift
//  task
//
//  Created by Technoventive on 09/11/2021.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate ,URLSessionDownloadDelegate{

    @IBOutlet weak var pv3: UIProgressView!
    @IBOutlet weak var pv2: UIProgressView!
    @IBOutlet weak var pV1: UIProgressView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    
    
    var imArray : [UIImage] = []
    var count  = 0;
    let url1 = URL(string: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg")!
    let url2 = URL(string: "https://file-examples-com.github.io/uploads/2017/10/file_example_PNG_2100kB.png")!
    let url3 = URL(string: "https://photojournal.jpl.nasa.gov/jpeg/PIA08506.jpg")!
    private let byteFormatter: ByteCountFormatter = {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useKB, .useMB]
            return formatter
        }()
    let config = URLSessionConfiguration.default
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for  _ in 1...3 {
            switch count{
            case 0 :
                let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
                session.downloadTask(with: url2).resume()
                count += 1
                break
            case 1 :
                let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
                session.downloadTask(with: url2).resume()
                count += 1
                break
            case 2 :
                let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
                session.downloadTask(with: url2).resume()
                count = 0;
                break
            default:
                let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
                session.downloadTask(with: url1).resume()
                count = 0;
                break
            }
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func downloadBtn(_ sender: Any) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            let written = byteFormatter.string(fromByteCount: totalBytesWritten)
            let expected = byteFormatter.string(fromByteCount: totalBytesExpectedToWrite)
            print("Downloaded \(written) / \(expected)")
            DispatchQueue.main.async {
                self.pV1.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            }
        }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imArray.append(image)
                    self.img1.image = image
                    self.updateImages();
                    
                }
            } else {
                fatalError("Cannot load the image")
            }

        }
    
    func updateImages(){
        var c = 0;
        for im in imArray{
            switch c{
            case 0 :
                self.img2.image = im
                c += 1
            case 1 :
                self.img3.image = im
                c += 1
            case 2 :
                self.img4.image = im
                c += 1
            default: break
            }
        }
    }

}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}
