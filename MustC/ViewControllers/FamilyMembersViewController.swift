import UIKit
import CoreData

class FamilyMembersViewController: UIViewController, AddFamilyMemberDelegate, PersistentContainerRequiring {
    
    var persistentContainer: NSPersistentContainer!
    
    
    @IBOutlet var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<FamilyMember>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let moc = persistentContainer.viewContext
        moc.automaticallyMergesChangesFromParent = true
        let request = NSFetchRequest<FamilyMember>(entityName: "FamilyMember")
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
        
    }
    
    func saveFamilyMember(withName name: String) {
        persistentContainer.performBackgroundTask { moc in
            moc.persist {
                let familyMember = FamilyMember(context: moc)
                familyMember.name = name
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController,
           let addFamilyMemberVC = navVC.viewControllers[0] as? AddFamilyMemberViewController {
            
            addFamilyMemberVC.delegate = self
        }
        
        guard let selectedIndex = tableView.indexPathForSelectedRow
        else { return }
        
        if let moviesVC = segue.destination as? MoviesViewController, let familyMember = fetchedResultsController?.object(at: selectedIndex) {
            moviesVC.persistentContainer = persistentContainer
            moviesVC.familyMember = familyMember
        }
        
        tableView.deselectRow(at: selectedIndex, animated: true)
        
    }
}

extension FamilyMembersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell"), let familyMember = fetchedResultsController?.object(at: indexPath)
        else { fatalError("Wrong cell identifier requested") }
        
//        let familyMember = familyMembers[indexPath.row]
        cell.textLabel?.text = familyMember.name
        return cell
    }
}

extension FamilyMembersViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndex = newIndexPath else { return }
            tableView.insertRows(at: [insertIndex], with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath else { return }
            tableView.deleteRows(at: [deleteIndex], with: .automatic)
        case .move:
            guard let fromIndex = indexPath, let toIndex = newIndexPath else { return }
            tableView.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath else { return }
            tableView.reloadRows(at: [updateIndex], with: .automatic)
        @unknown default:
            fatalError("Unhandled case")
        }
    }
}
