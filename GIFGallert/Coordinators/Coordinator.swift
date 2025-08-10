//
//  Coordinator.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }

    func start()
}
