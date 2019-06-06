//
//  ViewController.swift
//  DragAndDrop
//
//  Created by Yiyin Shen on 4/6/19.
//  Copyright © 2019 Sylvia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var appleImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInteraction()
    }

    private func configureInteraction() {
        view.addInteraction(UIDropInteraction(delegate: self))
        let dragInteraction = UIDragInteraction(delegate: self)
        dragInteraction.isEnabled = true
        appleImage.isUserInteractionEnabled = true
        appleImage.addInteraction(dragInteraction)
    }
}

extension ViewController: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = appleImage.image else { return [] }
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
}

extension ViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for dragItem in session.items {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { object, error in
                guard error == nil else { return print("Failed to load our dragged item") }
                guard let draggedImage = object as? UIImage else { return }
                DispatchQueue.main.async {
                    let centerPoint = session.location(in: self.view)
                    self.appleImage.image = draggedImage
                    self.appleImage.center = centerPoint
                }
            })
        }
    }
}

