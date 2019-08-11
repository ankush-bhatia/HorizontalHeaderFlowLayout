Pod::Spec.new do |spec|

# 1
spec.platform = :ios
spec.ios.deployment_target = '12.0'
spec.name = "HorizontalHeaderFlowLayout"
spec.summary = "Horizontal Header FlowLayout for Horizontal Collection View."
spec.description = <<-DESC
HorizontalHeaderFlowLayout lets a user to customise the header layout experience for horizontal collection view.
DESC
spec.requires_arc = true
spec.social_media_url = 'https://twitter.com/ankush1419'

# 2
spec.version = "1.0.0"

# 3
spec.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
spec.author = { "Ankush Bhatia" => "ankushbhatia1347@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
spec.homepage = "https://github.com/ankush-bhatia/HorizontalHeaderFlowLayout"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
spec.source = { :git => "https://github.com/ankush-bhatia/HorizontalHeaderFlowLayout.git",
:tag => "#{ spec.version }" }

# 7
spec.framework = "UIKit"

# 8
spec.source_files = "HorizontalHeaderFlowLayout/**/*.{swift}", "SessionManager/SessionManager/info.plist"

# 9
# spec.resources = "HorizontalHeaderFlowLayout/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
spec.swift_version = "5.0"

end
