FactoryGirl.define do
  factory :product_item do
    title 'Title'
    description 'Description'
    raw JSON.parse('{"$xmlns":{"pl1":"http://access.auth.theplatform.com/data/Account/2673532949"},"id":"http://data.media2.theplatform.com/media/data/Media/373829661","guid":"017128BE-7BE1-DBC7-895A-4184FDEF7A88","updated":1455377695000,"title":"Taken 3","author":"","description":"","added":1452798172000,"ownerId":"http://access.auth.theplatform.com/data/Account/2673532949","addedByUserId":"https://identity.auth.theplatform.com/idm/data/User/mpx/2693039","updatedByUserId":"https://identity.auth.theplatform.com/idm/data/User/mpx/2693039","version":1,"locked":false,"availableDate":0,"expirationDate":0,"categories":[{"name":"Movies","scheme":"","label":""}],"copyright":"","copyrightUrl":"","credits":[],"keywords":"","ratings":[],"countries":[],"excludeCountries":true,"text":"","content":[{"audioChannels":0,"audioSampleRate":0,"bitrate":0,"checksums":{},"contentType":"video","duration":0.000,"expression":"full","fileSize":0,"frameRate":0.0,"format":"M3U","height":0,"isDefault":false,"language":"","sourceTime":0.000,"url":"http://svr2.n2me.tv/vod/Taken_3_HD_2/Taken_3_HD_2.m3u8","width":0,"id":"http://data.media2.theplatform.com/media/data/MediaFile/373829663","guid":"U3c0yiffebmS_ErOecuTSo8FHHejwXm0","ownerId":"http://access.auth.theplatform.com/data/Account/2673532949","added":1452798201000,"updated":1455377695000,"addedByUserId":"https://identity.auth.theplatform.com/idm/data/User/service/2689174","updatedByUserId":"https://identity.auth.theplatform.com/idm/data/User/mpx/2693039","version":0,"locked":false,"description":"","title":"Taken_3_HD_2.m3u8","allowRelease":true,"assetTypeIds":["http://data.media2.theplatform.com/media/data/AssetType/372805779"],"assetTypes":["Movies"],"audioCodec":"","audioSampleSize":0,"downloadUrl":"","exists":true,"failoverStreamingUrl":"","failoverSourceUrl":"","filePath":"","isProtected":false,"isThumbnail":false,"mediaId":"http://data.media2.theplatform.com/media/data/Media/373829661","protectionKey":"","releases":[{"id":"http://data.media2.theplatform.com/media/data/Release/524869609","guid":"F5TMcx3seZlw201nP9SbFvaKab9koKG0","ownerId":"http://access.auth.theplatform.com/data/Account/2673532949","added":1455377695000,"updated":1455377695000,"addedByUserId":"https://identity.auth.theplatform.com/idm/data/User/mpx/2693039","updatedByUserId":"https://identity.auth.theplatform.com/idm/data/User/mpx/2693039","version":0,"locked":false,"description":"","approved":true,"delivery":"streaming","mediaId":"http://data.media2.theplatform.com/media/data/Media/373829661","fileId":"http://data.media2.theplatform.com/media/data/MediaFile/373829663","pid":"ztu4qGt70_RH","parameters":"","url":"http://link.theplatform.com/s/VAuWfC/ztu4qGt70_RH","restrictionId":"","adPolicyId":""}],"serverId":"","sourceMediaFileId":"","sourceUrl":"http://svr2.n2me.tv/vod/Taken_3_HD_2/Taken_3_HD_2.m3u8","storageUrl":"","streamingUrl":"http://svr2.n2me.tv/vod/Taken_3_HD_2/Taken_3_HD_2.m3u8","transferInfo":{"password":"","privateKey":"","userName":"","zones":["Public"],"supportsDownload":false,"supportsStreaming":true},"transformId":"","videoCodec":"","approved":true,"protectionScheme":"","aspectRatio":0.0,"previousLocations":[]}],"thumbnails":[{"audioChannels":0,"audioSampleRate":0,"bitrate":0,"checksums":{"md5":"0C61BA3751BE3DFEEF46EE32B6F0C939"},"contentType":"image","duration":0.000,"expression":"full","fileSize":401112,"frameRate":0.0,"format":"JPEG","height":1200,"isDefault":true,"language":"","sourceTime":0.000,"url":"akamai://tpr369599-nsu.akamaihd.net/369599/thumbnail/Supercloud_-_Trial_Account/357/525/TVNX_00363747_0216631_4.jpg","width":800,"id":"http://data.media2.theplatform.com/media/data/MediaFile/373829662","guid":"e6nsvjEcYCTzPV3o1rK7iD9RgewSB0Z3","ownerId":"http://access.auth.theplatform.com/data/Account/2673532949","added":1452798178000,"updated":1452798178000,"addedByUserId":"https://identity.auth.theplatform.com/idm/data/User/service/2689174","updatedByUserId":"https://identity.auth.theplatform.com/idm/data/User/mpx/2693039","version":1,"locked":false,"description":"","title":"TVNX_00363747_0216631_4.jpg","allowRelease":true,"assetTypeIds":[],"assetTypes":[],"audioCodec":"","audioSampleSize":0,"downloadUrl":"http://pmd369599tn.download.theplatform.com.edgesuite.net/Supercloud_-_Trial_Account/357/525/TVNX_00363747_0216631_4.jpg","exists":true,"failoverStreamingUrl":"","failoverSourceUrl":"","filePath":"Supercloud_-_Trial_Account/357/525/TVNX_00363747_0216631_4.jpg","isProtected":false,"isThumbnail":true,"mediaId":"http://data.media2.theplatform.com/media/data/Media/373829661","protectionKey":"","releases":[],"serverId":"http://data.media2.theplatform.com/media/data/Server/50245799","sourceMediaFileId":"","sourceUrl":"TVNX_00363747_0216631_4.jpg","storageUrl":"akamai://tpr369599-nsu.akamaihd.net/369599/thumbnail/Supercloud_-_Trial_Account/357/525/TVNX_00363747_0216631_4.jpg","streamingUrl":"http://pmd369599tn.download.theplatform.com.edgesuite.net/Supercloud_-_Trial_Account/357/525/TVNX_00363747_0216631_4.jpg","transformId":"","videoCodec":"","approved":true,"protectionScheme":"","aspectRatio":0.67,"previousLocations":[]}],"adminTags":[],"approved":true,"categoryIds":["http://data.media2.theplatform.com/media/data/Category/143941606"],"chapters":[],"link":"","pubDate":1452798172000,"defaultThumbnailUrl":"http://pmd369599tn.download.theplatform.com.edgesuite.net/Supercloud_-_Trial_Account/357/525/TVNX_00363747_0216631_4.jpg","originalOwnerIds":[],"provider":"","providerId":"","restrictionId":"","adPolicyId":"","pl1$overlay":""}')
  end
end
