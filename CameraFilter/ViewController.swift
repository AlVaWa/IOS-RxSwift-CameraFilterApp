//
//  ViewController.swift
//  CameraFilter
//
//  Created by Aleksander Waage on 30/06/2020.
//  Copyright © 2020 Waageweb. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoImageView.isHidden = true
        filterButton.isHidden = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
            let photosCVC = navC.viewControllers.first as? PhotoSelectionViewController else {
                fatalError("Segue destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func applyFilterTapped(_ sender: Any) {
        
        guard let sourceImage = self.photoImageView.image else { return }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filterImage in
            
            DispatchQueue.main.async {
                self.photoImageView.image = filterImage
            }
            
            }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.photoImageView.isHidden = false
        self.filterButton.isHidden = false
    }


}

