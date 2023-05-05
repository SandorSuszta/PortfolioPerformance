import UIKit

class CustomSearchBar: UIView {
    
    let searchIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "magnifyingglass")
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.backgroundColor = .clear
        return icon
    }()
    
    let searchTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 20, weight: .semibold)
        field.autocorrectionType = .no
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        configureWithShadow(cornerRadius: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        backgroundColor = .systemBackground
        addSubviews(searchIcon, searchTextField)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            searchIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            searchIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            searchIcon.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -padding * 2),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: self.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
