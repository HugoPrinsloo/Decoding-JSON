import UIKit
import PlaygroundSupport

let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")

struct 🚀NasaData: Codable {
    let date: String
    let url: String
    let title: String
}

class 🚀Decoder {
    func getDailyReport(completion:@escaping (_ weather: 🚀NasaData?, _ error:Error?) -> Void) {
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let nasaData = try decoder.decode(🚀NasaData.self, from: data)
                completion(nasaData, nil)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
}

let nasaManager = 🚀Decoder()

nasaManager.getDailyReport { (data, error) in
    if let data = data {
        let url = URL(string: data.url)
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                var image = UIImage(data: imageData!)
            }
        }
    }
}


class ResultView: UIView {
    
    var data = 🚀NasaData(date: "24 June", url: "https://apod.nasa.gov/apod/image/1806/sts98plume_nasa_1111.jpg", title: "Rocket Plume Shadow Points to the Moon")

    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 18)
        return l
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()

    let imageView: UIImageView = {
        let l = UIImageView()
        l.contentMode = .scaleAspectFill
        l.clipsToBounds = true
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        addSubview(stackView)

        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        titleLabel.text = data.title
        dateLabel.text = data.date
        
        let url = URL(string: data.url)
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                var image = UIImage(data: imageData!)
                self.imageView.image = image
            }
        }

    }
}

let rs = ResultView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
PlaygroundPage.current.liveView = rs


