# Gungnir'i arka planda çalıştır ve logları hem dosyaya hem de notify'e gönder
./gungnir -f -r wildcards.txt > gungnir.log | ./notify -silent -id ct-log > /dev/null &

while true; do
    # subfinder ile subdomainleri bul ve sublist.txt dosyasına ekle
    ./subfinder -silent -dL wildcards.txt >> sublist.txt > /dev/null

    # gungnir.log dosyasındaki yeni subdomainleri sublist.txt dosyasına ekle (eğer log boş değilse)
    if [ -s gungnir.log ]; then
        ./anew sublist.txt < gungnir.log
    fi

    # sublist.txt dosyasındaki subdomainleri temizle ve optimize et
    sort -u sublist.txt >> clearlist.txt

    # 24 saat bekle (86400 saniye)
    sleep 86400

    # sublist.txt ve clearlist.txt dosyalarını birleştir ve merged.txt dosyasına yaz
    cat domain.txt clearlist.txt | ./anew > merged.txt
    
    # nuclei ile subdomainlerdeki açıklıkları tara (her hafta pazar günü)
    if (( $(date +%j) % 7 == 0 )); then
        ./nuclei -l merged.txt -config nuclie-config.yaml -o nuclei_scan.log | ./notify -silent -id tool-scan > /dev/null
    fi

    # getallscopes.py ve filter.py işlemleri sadece her ayın 1'inde çalışacak
    if [ $(date +%d) -eq 1 ]; then
        python3 getallscopes.py -o all-scope.txt | python3 filter.py -f all-scope.txt -d | python3 filter.py -f all-scope.txt -w
    fi

    # Log dosyasını belirli bir boyutta yedekle ve sıfırla
    if [ $(stat -c%s gungnir.log) -gt 524288000 ]; then # 500 MB
        timestamp=$(date +%Y%m%d-%H%M%S)
        mv gungnir.log "gungnir_backup_$timestamp.log"
        > gungnir.log
        echo "Log dosyası 500 MB sınırını aştı, yedeklendi ve sıfırlandı: gungnir_backup_$timestamp.log"
    fi
done
