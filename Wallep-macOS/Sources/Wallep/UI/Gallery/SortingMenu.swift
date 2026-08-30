import SwiftUI

public struct SortingMenu: View {
    @Binding var selectedSort: LibrarySortOption
    
    public init(selectedSort: Binding<LibrarySortOption>) {
        self._selectedSort = selectedSort
    }
    
    public var body: some View {
        Picker("Sort", selection: $selectedSort) {
            ForEach(LibrarySortOption.allCases) { opt in
                Text(opt.rawValue).tag(opt)
            }
        }
        .pickerStyle(.menu)
        .frame(width: 180)
    }
}
