struct StringComparator {
    let lhs: String
    let rhs: String
    init(lhs: String, rhs: String) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
    func areStringsSimilar() -> Bool {
        return similarity(lhs, rhs) > 0.8
    }
    
    private func levenshtein(_ lhs: String, _ rhs: String) -> Int {
        let lhs = Array(lhs)
        let rhs = Array(rhs)
        let empty = [Int](repeating: 0, count: rhs.count + 1)
        var last = [Int](0...rhs.count)

        for (i, l) in lhs.enumerated() {
            var current = [i + 1] + empty
            for (j, r) in rhs.enumerated() {
                current[j + 1] = l == r ? last[j] : min(last[j], last[j + 1], current[j]) + 1
            }
            last = current
        }

        return last[rhs.count]
    }
    
    private func similarity(_ lhs: String, _ rhs: String) -> Double {
        let maxLength = max(lhs.count, rhs.count)
        guard maxLength > 0 else { return 1.0 }
        let distance = Double(levenshtein(lhs.lowercased(), rhs.lowercased()))
        return 1.0 - (distance / Double(maxLength))
    }
}
