//___FILEHEADER___

import UIKit
import Base
import RxCocoa
import RxSwift

class ___FILEBASENAMEASIDENTIFIER___: ___VARIABLE_cocoaTouchSubclass___ {
    typealias ViewModelType = ___VARIABLE_viewModelClass___
    var disposeBag: DisposeBag = DisposeBag()
    var viewModel: ___VARIABLE_viewModelClass___!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        binds()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - HasViewModel
extension ___FILEBASENAMEASIDENTIFIER___: HasViewModel {
    func setup() {
        
    }
    
    func binds {
        
    }
}
