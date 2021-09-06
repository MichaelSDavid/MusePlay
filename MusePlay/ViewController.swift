// Import(s)
import UIKit

// Main ViewController class
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Init outlet(s) and song list
    @IBOutlet var table: UITableView!
    var songs = [Song]()
    
    // Implement UITableView methods //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        
        // Config cell properties
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artistName
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Spread out the spacing between each row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Present the player //
        
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else {
            return
        }
        
        // Assign songs and pos
        vc.songs = songs
        vc.position = position
        
        present(vc, animated: true)
    }
    
    // Append each song playlist to main songs array
    func configureSongs() {
        songs.append(Song(name: "Don't Start Now",
                          artistName: "Dua Lipa",
                          imageName: "cov1",
                          trackName: "song1"))
        songs.append(Song(name: "Unity",
                          artistName: "TheFatRat",
                          imageName: "cov2",
                          trackName: "song2"))
        songs.append(Song(name: "Counting Stars",
                          artistName: "One Republic",
                          imageName: "cov3",
                          trackName: "song3"))
        songs.append(Song(name: "Feels Like Summer",
                          artistName: "Samuel Jack",
                          imageName: "cov4",
                          trackName: "song4"))
        songs.append(Song(name: "Mine",
                          artistName: "Felix Cartal",
                          imageName: "cov5",
                          trackName: "song5"))
    }
    
    // Config songs on load View
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        table.delegate = self
        table.dataSource = self
    }
    
}

// Song from 4 given attributes
struct Song {
    let name: String
    let artistName: String
    let imageName: String
    let trackName: String
}
