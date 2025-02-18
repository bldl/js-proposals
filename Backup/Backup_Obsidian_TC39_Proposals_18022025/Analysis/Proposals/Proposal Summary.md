
```dataviewjs

const amounts = await dv.query(`
TABLE length(rows) AS "Count"
WHERE contains(file.tags, "#InactiveTag") 
   OR contains(file.tags, "#Stage0Tag") 
   OR contains(file.tags, "#Stage1Tag")
   OR contains(file.tags, "#Stage2Tag")
   OR contains(file.tags, "#Stage_2_7Tag")
   OR contains(file.tags, "#Stage3Tag")
   OR contains(file.tags, "#Stage4Tag")
GROUP BY file.tags AS "Proposal Stages"
`);

if (amounts.successful) { 
    const sum = amounts.value.values
        .map(a => a[1]) 
        .reduce((tmp, curr) => tmp + curr, 0); 

    amounts.value.values.push(["<span style='float: right'><strong>Total:</strong></span>", sum]);

    dv.table(amounts.value.headers, amounts.value.values);

    
} else {
    dv.paragraph("~~~~\n" + amounts.error + "\n~~~~");
}


```
