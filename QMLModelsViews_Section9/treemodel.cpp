#include "treemodel.h"
#include "treeitem.h"

TreeModel::TreeModel(QObject *parent)
    : QAbstractItemModel(parent)
{
    rootItem = new TreeItem({tr("Simple Tree Model")});
    createModelData(rootItem);
}

TreeModel::~TreeModel()
{
    delete rootItem;
}

int TreeModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return static_cast<TreeItem*>(parent.internalPointer())->columnCount();
    return rootItem->columnCount();
}

QHash<int, QByteArray> TreeModel::roleNames() const
{
    QHash<int, QByteArray> mapping {
        {Qt::DisplayRole, "displaying"},
        {Qt::EditRole, "edition"}
    };
    return mapping;
}

QVariant TreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role != Qt::DisplayRole && role != Qt::EditRole)
        return QVariant();

    TreeItem *item = static_cast<TreeItem*>(index.internalPointer());
    return item->data(index.column());
}

QVariant TreeModel::headerData(int section, Qt::Orientation orientation,
                               int role) const
{
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole)
        return rootItem->data(section);

    return QVariant();
}

QModelIndex TreeModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent))
        return QModelIndex();

    TreeItem *parentItem;

    if (!parent.isValid())
        parentItem = rootItem;
    else
        parentItem = static_cast<TreeItem*>(parent.internalPointer());

    TreeItem *childItem = parentItem->child(row);
    if (childItem)
        return createIndex(row, column, childItem);
    return QModelIndex();
}

QModelIndex TreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return QModelIndex();

    TreeItem *childItem = static_cast<TreeItem*>(index.internalPointer());
    TreeItem *parentItem = childItem->parentItem();

    if (parentItem == rootItem)
        return QModelIndex();

    return createIndex(parentItem->row(), 0, parentItem);
}

int TreeModel::rowCount(const QModelIndex &parent) const
{
    TreeItem *parentItem;
    if (parent.column() > 0)
        return 0;

    if (!parent.isValid())
        parentItem = rootItem;
    else
        parentItem = static_cast<TreeItem*>(parent.internalPointer());

    return parentItem->childCount();
}

void TreeModel::createModelData(TreeItem *parent)
{
    QList<TreeItem *> parents;
    parents << parent;
    QList<QVariant> columnData;
    QString columnString;

    int famMemberNum;
    int numberOfFams = 3;
    QStringList firstNames;
    QStringList ages;
    QStringList phoneNumbers;

    for (int p = 0; p < numberOfFams; p++)
    {
        switch (p) {
        case 0:
            columnString = "Doe Family";
            firstNames = {"John", "Jane", "George", "Lily"};
            ages = {"49", "48", "12", "10"};
            phoneNumbers = {"111-111-1111", "222-222-2222", "333-333-3333", "444-444-4444"};
            famMemberNum = 4;
            break;
        case 1:
            columnString = "Smith Family";
            firstNames = {"Sarah", "Bob", "Julia"};
            ages = {"14", "45", "51"};
            phoneNumbers = {"555-555-5555", "666-666-6666", "777-777-7777"};
            famMemberNum = 3;
            break;
        case 2:
            columnString = "Wolf Family";
            firstNames = {"Jose", "Joe"};
            ages = {"38", "35"};
            phoneNumbers = {"888-888-8888", "999-999-9999"};
            famMemberNum = 2;
            break;
        default:
            break;
        }

        columnData.clear();
        columnData << columnString;
        //Adds an element containing columnData to the model
        parents.last()->appendChild(new TreeItem(columnData, parents.last()));
        //Puts the next element added to the model into a subgroup of the previously added element
        parents << parents.last()->child(parents.last()->childCount()-1);

        for(int c = 0; c < famMemberNum; c++)
        {
            columnString = firstNames[c];
            columnData.clear();
            columnData << columnString;
            parents.last()->appendChild(new TreeItem(columnData, parents.last()));
            parents << parents.last()->child(parents.last()->childCount()-1);

            for(int s = 0; s < 2; s++)
            {
                switch (s) {
                case 0:
                    columnString = "Age: " + ages[c];
                    break;
                case 1:
                    columnString = "Phone: " + phoneNumbers[c];
                    break;
                default:
                    break;
                }

                columnData.clear();
                columnData << columnString;
                parents.last()->appendChild(new TreeItem(columnData, parents.last()));
                if (s==1) {
                    //Puts the next element added to the model into the parent group of the previously added element
                    parents.pop_back();
                }
            }

            if (c==(famMemberNum - 1)) {
                parents.pop_back();
            }
        }
    }
}

bool TreeModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid())
        return false;

    if (role != Qt::DisplayRole && role != Qt::EditRole)
        return false;

    TreeItem *item = static_cast<TreeItem*>(index.internalPointer());
    item->setData(index.column(), value);
    emit dataChanged(index, index);
    return true;
}

Qt::ItemFlags TreeModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    else
        return Qt::ItemIsEditable;
}
