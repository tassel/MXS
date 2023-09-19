for o in (for o in selection where isgroupmember o and not isgrouphead o.parent collect o) do
(
	P = o.parent
	detachNodesFromGroup o
	o.parent = P
)
