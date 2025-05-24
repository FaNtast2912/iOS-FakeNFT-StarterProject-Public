//
//  CartManager.swift
//  FakeNFT
//
//  Created by Kaider on 24.05.2025.
//

import Foundation
import CoreData
import Combine

final class CartManager: ObservableObject {
    @Published private(set) var cartItems: [CartItem] = []

    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    private var fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchCart()
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
            .sink { [weak self] _ in
                self?.fetchCart()
            }
            .store(in: &cancellables)
    }

    // MARK: - Добавить товар в корзину
    
    func add(product: Product) {
        // Проверка, есть ли уже CartItem с этим product
        if let existingItem = cartItems.first(where: { $0.product?.id == product.id }) {
            existingItem.quantity += 1
        } else {
            let item = CartItem(context: context)
            item.id = UUID()
            item.quantity = 1
            item.product = product
        }
        save()
    }

    // MARK: - Удалить товар из корзины
    
    func remove(item: CartItem) {
        context.delete(item)
        save()
    }

    // MARK: - Очистить корзину
    
    func clear() {
        for item in cartItems {
            context.delete(item)
        }
        save()
    }

    // MARK: - Изменить количество
    
    func updateQuantity(for item: CartItem, quantity: Int16) {
        guard quantity > 0 else {
            remove(item: item)
            return
        }
        item.quantity = quantity
        save()
    }

    // MARK: - Получить все элементы корзины
    
    func fetchCart() {
        let request = CartItem.fetchRequest()
        request.sortDescriptors = []
        if let result = try? context.fetch(request) as? [CartItem] {
            cartItems = result
        }
    }

    // MARK: - Сохранить изменения
    
    private func save() {
        do {
            try context.save()
            fetchCart()
        } catch {
            print("Ошибка сохранения корзины: \(error)")
        }
    }
}
