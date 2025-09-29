#!/bin/bash

# Create Databases folder if it doesn't exist
mkdir -p Databases
cd Databases

while true; do
    clear
    echo "Main Menu:"
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect To Database"
    echo "4) Drop Database"
    echo "5) Exit"
    read -p "Choose option: " choice

    case $choice in
        1)
            read -p "Enter DB name: " db
            mkdir "$db" 2>/dev/null || echo "DB already exists."
            read -p "Press Enter to continue..."
            ;;
        2)
            ls -d */
            read -p "Press Enter to continue..."
            ;;
        3)
             ls -d */
            read -p "Enter DB name: " db
            if [ -d "$db" ]; then
                cd "$db" || exit
                while true; do
                    clear
                    echo "Database [$db] Menu:"
                    echo "1) Create Table"
                    echo "2) List Tables"
                    echo "3) Drop Table"
                    echo "4) Insert into Table"
                    echo "5) Select From Table"
                    echo "6) Update Table"
                    echo "7) Back to Main Menu"
                    read -p "Choose option: " db_choice

                    case $db_choice in
                        1)
                            read -p "Enter table name: " table
                            read -p "Enter columns (comma separated): " cols
                            echo "$cols" > "$table.csv"
                            
                            # Ask for primary key
                            read -p "Enter primary key column number (1 to $(echo "$cols" | awk -F',' '{print NF}')): " pk_col
                            echo "$pk_col" > ".$table.pk"
                            echo "Table created with primary key on column $pk_col"
                            read -p "Press Enter to continue..."
                            ;;
                        2)
                            ls *.csv 2>/dev/null
                            read -p "Press Enter to continue..."
                            ;;
                        3)
                             ls *.csv 2>/dev/null
                            read -p "Enter table name: " table
                            rm "$table.csv" 2>/dev/null
                            read -p "Press Enter to continue..."
                            ;;
                        4)
                             ls *.csv 2>/dev/null
                            read -p "Enter table name: " table
                            if [ -f "$table.csv" ]; then
                                column -t -s "," "$table.csv"
                                
                                # Get number of columns from header
                                total_cols=$(head -1 "$table.csv" | awk -F',' '{print NF}')
                                
                                read -p "Enter row values (comma separated, $total_cols columns): " row
                                
                                # Count number of columns in the input
                                input_cols=$(echo "$row" | awk -F',' '{print NF}')
                                
                                # Validate column count
                                if [ "$input_cols" -ne "$total_cols" ]; then
                                    echo "Error: Expected $total_cols columns, but got $input_cols columns!"
                                    read -p "Press Enter to continue..."
                                    continue
                                fi
                                
                                # Check if primary key file exists
                                if [ -f ".$table.pk" ]; then
                                    pk_col=$(cat ".$table.pk")
                                    # Extract the primary key value from the new row
                                    pk_value=$(echo "$row" | cut -d',' -f"$pk_col")
                                    
                                    # Check if this primary key already exists (skip header line)
                                    if tail -n +2 "$table.csv" | cut -d',' -f"$pk_col" | grep -q "^$pk_value$"; then
                                        echo "Error: Primary key value '$pk_value' already exists!"
                                        read -p "Press Enter to continue..."
                                        continue
                                    fi
                                fi
                                
                                echo "$row" >> "$table.csv"
                                echo "Row inserted successfully!"
                            else
                                echo "Table not found!"
                            fi
                            read -p "Press Enter to continue..."
                            ;;
                        5)
                               ls *.csv 2>/dev/null
                            read -p "Enter table name: " table
                            if [ -f "$table.csv" ]; then
                                column -t -s "," "$table.csv"
                            else
                                echo "Table not found!"
                            fi
                            read -p "Press Enter to continue..."
                            ;;
                        6)
                            ls *.csv 2>/dev/null
                            read -p "Enter table name: " table
                            if [ -f "$table.csv" ]; then
                                column -t -s "," "$table.csv"
                                echo ""
                                
                                # Get table boundaries
                                total_rows=$(wc -l < "$table.csv")
                                total_cols=$(head -1 "$table.csv" | awk -F',' '{print NF}')
                                
                                echo "Table has $((total_rows - 1)) data rows and $total_cols columns"
                                
                                read -p "Enter row number to update (2 to $total_rows): " row_num
                                
                                # Validate row number
                                if [ "$row_num" -lt 2 ] || [ "$row_num" -gt "$total_rows" ]; then
                                    echo "Error: Row number out of range!"
                                    read -p "Press Enter to continue..."
                                    continue
                                fi
                                
                                read -p "Enter column number to update (1 to $total_cols): " col_num
                                
                                # Validate column number
                                if [ "$col_num" -lt 1 ] || [ "$col_num" -gt "$total_cols" ]; then
                                    echo "Error: Column number out of range!"
                                    read -p "Press Enter to continue..."
                                    continue
                                fi
                                
                                read -p "Enter new value: " new_value
                                
                                # Get the row to update
                                row_content=$(sed -n "${row_num}p" "$table.csv")
                                # Update specific column
                                updated_row=$(echo "$row_content" | awk -F',' -v col="$col_num" -v val="$new_value" '{OFS=","; $col=val; print}')
                                # Replace the row
                                sed -i "${row_num}s/.*/$updated_row/" "$table.csv"
                                echo "Cell updated successfully!"
                            else
                                echo "Table not found!"
                            fi
                            read -p "Press Enter to continue..."
                            ;;
                        7)
                            cd ..
                            break
                            ;;
                        *)
                            echo "Invalid option"
                            read -p "Press Enter to continue..."
                            ;;
                    esac
                    
                done
            else
                echo "Database not found!"
                read -p "Press Enter to continue..."
            fi
            ;;
        4)
             ls -d */
            read -p "Enter DB name: " db
            rm -r "$db" 2>/dev/null || echo "DB not found."
            read -p "Press Enter to continue..."
            ;;
        5)
            echo "Goodbye!"
            exit
            ;;
        *)
            echo "Invalid option"
            read -p "Press Enter to continue..."
            ;;
    esac
    
done