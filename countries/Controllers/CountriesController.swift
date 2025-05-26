import Foundation

final class CountriesController: Sendable {
    typealias CountryTransform = @Sendable ([Country]) -> [Country]

    private let countriesService: CountriesService
    private let countriesCache: CountriesCache?
    private let queue: DispatchQueue
    private let countriesTransform: CountryTransform

    init(service: CountriesService = CountriesService(),
         cache: CountriesCache? = try? CountriesCache(),
         queue: DispatchQueue = DispatchQueue(label: "se.belous.dev.countries.controller.queue", qos: .userInitiated),
         countriesTransform: @escaping CountryTransform = { countries in countries.sorted(by: { $0.name.common < $1.name.common })}) {
        self.countriesService = service
        self.countriesCache = cache
        self.queue = queue
        self.countriesTransform = countriesTransform
    }

    func loadCountries(completion: @escaping @Sendable @MainActor ([Country]?) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }

            if let cachedCountries = self.countriesCache?.getCountries() {
                self.completeOnMainWithTransform(completion, with: cachedCountries)
                return
            }

            self.countriesService.fetchCountries { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let countries):
                    self.countriesCache?.saveCountries(countries)
                    self.completeOnMainWithTransform(completion, with: countries)

                case .failure(let error):
                    print("Failed to fetch countries: \(error)")
                    self.completeOnMainWithTransform(completion, with: self.countriesCache?.getCountries())
                }
            }
        }
    }

    func loadCountryDetails(country: Country, completion: @escaping @Sendable @MainActor (CountryDetails?) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }

            if let cachedDetails = self.countriesCache?.getCountryDetails(for: country.cca2) {
                self.completeOnMain(completion, with: cachedDetails)
                return
            }

            self.countriesService.fetchCountryDetails(code: country.cca2) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let detailsArray):
                    if let details = detailsArray.first {
                        self.countriesCache?.saveCountryDetails(details, for: country.cca2)
                        self.completeOnMain(completion, with: details)
                    } else {
                        self.completeOnMain(completion, with: nil)
                    }

                case .failure(let error):
                    print("Failed to fetch country details for \(country.cca2): \(error)")
                    self.completeOnMain(completion, with: self.countriesCache?.getCountryDetails(for: country.cca2))
                }
            }
        }
    }

    private func completeOnMain<T>(_ completion: @escaping @Sendable @MainActor (T) -> Void, with result: T) where T: Sendable {
        DispatchQueue.main.async {
            completion(result)
        }
    }

    private func completeOnMainWithTransform(_ completion: @escaping @Sendable @MainActor ([Country]?) -> Void, with countries: [Country]?) {
        completeOnMain(completion, with: countries.map(self.countriesTransform))
    }
}
