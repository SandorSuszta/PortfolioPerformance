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
            searchIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            searchIcon.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            searchIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            searchIcon.widthAnchor.constraint(equalTo: heightAnchor, constant: -padding * 2)
        ])
    }
}
