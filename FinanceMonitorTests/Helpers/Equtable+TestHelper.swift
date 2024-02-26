@testable import FinanceMonitor
import Spry

extension APIError: AutoEquatable, SpryEquatable { }
extension ContainerError: AutoEquatable, SpryEquatable { }
extension ContainerMultipleError: AutoEquatable, SpryEquatable { }
extension TransactionModel.TransactionItem: AutoEquatable {}
