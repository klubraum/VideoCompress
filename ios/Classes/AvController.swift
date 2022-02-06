
import AVFoundation
import MobileCoreServices

class AvController: NSObject {
    public func getVideoAsset(_ url:URL)->AVURLAsset {
        return AVURLAsset(url: url)
    }
    
    public func getTrack(_ asset: AVURLAsset)->AVAssetTrack? {
        var track : AVAssetTrack? = nil
        let group = DispatchGroup()
        group.enter()
        asset.loadValuesAsynchronously(forKeys: ["tracks"], completionHandler: {
            var error: NSError? = nil;
            let status = asset.statusOfValue(forKey: "tracks", error: &error)
            if (status == .loaded) {
                track = asset.tracks(withMediaType: AVMediaType.video).first
            }
            group.leave()
        })
        group.wait()
        return track
    }
    
    public func getVideoOrientation(_ track:AVAssetTrack)-> Int? {
        let txf = track.preferredTransform
        let degrees = Int((atan2(txf.b, txf.a)) * (180 / Double.pi))
        if (degrees < 0) {
            return degrees + 360;            
        }
        return degrees
    }
    
    public func getMetaDataByTag(_ asset:AVAsset,key:String)->String {
        for item in asset.commonMetadata {
            if item.commonKey?.rawValue == key {
                return item.stringValue ?? "";
            }
        }
        return ""
    }
}
