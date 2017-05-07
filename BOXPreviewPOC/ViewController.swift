//
//  ViewController.swift
//  BOXPreviewPOC
//
//  Created by Mohga Nabil on 5/7/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import BoxContentSDK
class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let clientID = "qjsxwy3b7p0jofoe9u7m98fi1i3lc8v4"
		let clientSecret = "sAwYToBNyXjulHk1EiqDP4RhcaHrdM0a"
		let redirectURI = "https://lighthouse.ibm.com"
		BOXContentClient.setClientID(clientID, clientSecret: clientSecret, redirectURIString: redirectURI)
		
		previewBOXFile()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func previewBOXFile(){
		let client = BOXContentClient.default()!
		if client.session.isAuthorized(){
			self.getSharedLinkInfo(sharedLink: NSURL(string:"https://ibm.box.com/s/08knplp2380lqdf3epwqaj4atemku6rc")! as URL!){ (file, error) in
				if error == nil {
					let previewViewController = BOXFilePreviewController(contentClient: BOXContentClient.default(), file: file!)!
					previewViewController.view.translatesAutoresizingMaskIntoConstraints = false
					self.addChildViewController(previewViewController)
					self.view.addSubview(previewViewController.view)
					previewViewController.didMove(toParentViewController: self)
					
				}
			}
		}else{
			client.authenticate(completionBlock: { (user, error) in
				if error == nil{
					self.getSharedLinkInfo(sharedLink: NSURL(string:"https://ibm.box.com/s/08knplp2380lqdf3epwqaj4atemku6rc")! as URL!){ (file, error) in
						if error == nil {
							let previewViewController = BOXFilePreviewController(contentClient: BOXContentClient.default(), file: file!)!
							previewViewController.view.translatesAutoresizingMaskIntoConstraints = false
							self.addChildViewController(previewViewController)
							self.view.addSubview(previewViewController.view)
							previewViewController.didMove(toParentViewController: self)
							
						}
					}
				}
			})
		}

	}
	
	func getSharedLinkInfo(sharedLink:URL,completionHandler:@escaping (_ fileInfo:BOXFile?,_ error:NSError?)-> Void){
		let client = BOXContentClient.default()!
			client.sharedItemInfoRequest(withSharedLinkURL: sharedLink, password: "").perform { (item, error) in
			if item != nil{
				if item!.isFile{
					completionHandler(item as? BOXFile,nil)
				}
			}else{
				completionHandler(nil,error as NSError?)
			}
		}
		
	}

}

