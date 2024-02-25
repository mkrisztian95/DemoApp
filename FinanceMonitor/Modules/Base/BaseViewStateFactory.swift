import Depin

class BaseViewStateFactory {

    @Injected var i18n: I18n

    func formatCurrency(amount: Double, code: String) -> String {
        amount.formatted(.currency(code: code))
    }
}
