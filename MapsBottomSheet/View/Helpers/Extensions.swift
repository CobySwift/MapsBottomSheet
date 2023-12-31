//
//  Extensions.swift
//  MapsBottomSheet
//
//  Created by COBY_PRO on 2023/07/31.
//

import SwiftUI

// MARK: Custom View Extensions
// MARK: Custom Bottom Sheet Extracting From Native SwiftUI
extension View {
    @ViewBuilder
    func bottomSheet<Content: View>(
        presentationDetents: Set<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: @escaping () -> ()
    ) -> some View {
        self
            .sheet(isPresented: isPresented) {
                onDismiss()
            } content: {
                content()
                    .presentationDetents(presentationDetents)
                    .presentationDragIndicator(dragIndicator)
                    .interactiveDismissDisabled(interactiveDisabled)
                    .presentationBackgroundInteraction(.enabled) // iOS 16.4
                    .onAppear {
                        // MARK: Custom Code For Bottom Sheet
                        // Finding the Presented View Controller
                        guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if let controller = windows.windows.first?.rootViewController?.presentedViewController,
                               let sheet = controller.presentationController as? UISheetPresentationController {
                                
                                // FOR TRANSPARENT BACKGROUND
                                if isTransparentBG {
                                    controller.view.backgroundColor = .clear
                                }
                                
                                // FROM THIS EXTRACTING PRESENTATION CONTROLLER
                                // SOMETIMES BUTTONS AND ACTIONS WILL BE TINTED IN HIDDEN FORM
                                // TO AVOID THIS
                                controller.presentingViewController?.view.tintAdjustmentMode = .normal
                                
                                // MARK: As Usual Set Properties What Ever Your Wish Here With Sheet Controller
                                sheet.largestUndimmedDetentIdentifier = largestUndimmedIdentifier
                                sheet.preferredCornerRadius = sheetCornerRadius
                            } else {
                                print("NO CONTROLLER FOUND")
                            }
                        }
                    }
            }
    }
}
