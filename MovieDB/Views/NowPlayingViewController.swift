//
//  NowPlayingViewController.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import UIKit
import MBProgressHUD

class NowPlayingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    lazy var viewModel = NowPlayingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        viewModel.viewDidLoadCalled()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let contentY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if contentHeight - contentY <= height {
            guard viewModel.canScroll() else { return }
            viewModel.fetchNextSetOfMovies()
        }
    }
}

extension NowPlayingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.noOfMovies
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.movieCell.rawValue, for: indexPath) as? MovieCollectionViewCell else { return MovieCollectionViewCell() }

        if let info = viewModel.getInfo(at: indexPath.item) {
            cell.setup(with: info)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = view.frame.size.width/2
        return CGSize(width: width - 10, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

private extension NowPlayingViewController {

    func setupBinding() {

        viewModel.reload.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }

        viewModel.showLoader.bind { [weak self] show in
            guard let self = self else { return }
            if show {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }

        viewModel.showError.bind { [weak self] error in
            let message = error?.localizedDescription ?? ""
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
