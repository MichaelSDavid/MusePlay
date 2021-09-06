// Import(s)
import UIKit
import AVFoundation

// Player class
class PlayerViewController: UIViewController {
    
    // Init outlet(s) and var(s)
    @IBOutlet var holder: UIView!
    public var position: Int = 0
    public var songs: [Song] = []
    var player: AVAudioPlayer?
    
    // UI features
    private let songImageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let songNameLabel: UILabel =  {
        let label = UILabel()
        label.numberOfLines = 0 // Line wrapping
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    private let artistNameLabel: UILabel =  {
        let label = UILabel()
        label.numberOfLines = 0 // Line wrapping
        label.textAlignment = .center
        return label
    }()
    
    let playPauseButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Config player
    func configure() {
        // Set up player
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                return
            }
            player.volume = 0.5
            player.play()
        } catch {
            print("ERROR")
        }
        // Set up UI elements
        
        // Cover images
        songImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: holder.frame.size.width-20,
                                     height: holder.frame.size.width-20)
        songImageView.image = UIImage(named: song.imageName)
        holder.addSubview(songImageView)
        
        // Labels
        songNameLabel.frame = CGRect(x: 10,
                                     y: songImageView.frame.size.height+10,
                                     width: holder.frame.size.width-20,
                                     height: 70)
        artistNameLabel.frame = CGRect(x: 10,
                                     y: songImageView.frame.size.height+80,
                                     width: holder.frame.size.width-20,
                                     height: 70)
        songNameLabel.text = song.name
        artistNameLabel.text = song.artistName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(artistNameLabel)
        
        // Controls and vol
        // let playPauseButton = UIButton() //
        let prevButton = UIButton()
        let nextButton = UIButton()
        
        let yPos = artistNameLabel.frame.origin.y + 100
        let size: CGFloat = 70
        
        playPauseButton.frame = CGRect(x: (holder.frame.size.width-size)/2.0,
                                       y: yPos,
                                       width: size,
                                       height: size)
        prevButton.frame = CGRect(x: 20,
                                  y: yPos,
                                  width: size,
                                  height: size)
        nextButton.frame = CGRect(x: holder.frame.size.width-size-20,
                                  y: yPos,
                                  width: size,
                                  height: size)
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextkButton), for: .touchUpInside)
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        prevButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        
        holder.addSubview(playPauseButton)
        holder.addSubview(prevButton)
        holder.addSubview(nextButton)
        
        let slider = UISlider(frame: CGRect(x: 20,
                                             y: holder.frame.size.height-100,
                                             width: holder.frame.size.width-40,
                                             height: 50))
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        slider.value = 0.5
        holder.addSubview(slider)
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        player?.volume = value
    }
    
    @objc func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.songImageView.frame = CGRect(x: 30,
                                                  y: 30,
                                                  width: self.holder.frame.size.width-60,
                                                  height: self.holder.frame.size.width-60)
            })
        } else {
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.songImageView.frame = CGRect(x: 10,
                                                  y: 10,
                                                  width: self.holder.frame.size.width-20,
                                                  height: self.holder.frame.size.width-20)
            })
        }
    }
    
    @objc func didTapPrevButton() {
        if position > 0 {
            position -= 1
            player?.stop()
            for sv in holder.subviews {
                sv.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapNextkButton() {
        if position < (songs.count - 1) {
            position += 1
            player?.stop()
            for sv in holder.subviews {
                sv.removeFromSuperview()
            }
            configure()
        }
    }
    
    // Configure when sub view is brought up
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }

}
